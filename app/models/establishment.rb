class Establishment < ActiveRecord::Base
  belongs_to :type
  has_many :infractions,
    :dependent => :destroy,
    :after_remove => :update_infractions_cache!,
    :order => 'infractions.judgment_date DESC, infractions.infraction_date DESC'
  has_many :owners,
    :through => :infractions,
    :uniq => true
  has_friendly_id :name, :use_slug => true

  attr_accessible :name, :address, :city, :type_id

  validates_presence_of :name, :address, :city, :type
  validates_uniqueness_of :name, :scope => [:address, :city]

  before_create :geocode
  before_save :update_fingerprints

  scope :geocoded, where('latitude IS NOT NULL', 'longitude IS NOT NULL')
  scope :by_most_infractions, order('infractions_count DESC')
  scope :by_highest_infractions, order('infractions_amount DESC')
  scope :by_judgment_date, includes(:infractions).order('infractions.judgment_date DESC')

  def self.find_or_create_by_name_and_address_and_city(name, address, city, attributes = {})
    find_or_create_by_name_fingerprint_and_address_fingerprint_and_city_fingerprint(
    name.fingerprint,
    address.fingerprint,
    city.fingerprint,
    {
      :name => name,
      :address => address,
      :city => city,
    }.merge(attributes))
  end

  def reviews
    term = name.gsub(/ Inc\.?/i, '')
    response = Yelp.reviews :term => term, :location => full_address
    if response && response['name'] == term
      response['reviews']
    else
      []
    end
  end

  def short_address
    if geocoded? && street
      street
    else
      address
    end
  end

  def full_address
    if geocoded? && street && locality
      "#{street}, #{locality}"
    else
      "#{address}, #{city}"
    end
  end

  def geocode
    @@geocoder ||= Graticule.service(:google).new 'ABQIAAAACjg5EelPDHaItWLh83iDnxSTO_huFvQjFKOycbqUllPdGQkbfRRbpq18tH_FX8TyWWBPGwtlKiXNdA'

    begin
      location = @@geocoder.locate "#{address}, #{city}"
      %w(latitude longitude street region locality country postal_code).each do |attr|
        value = location.send(attr)
        self[attr] = value.is_a?(String) ? value.force_encoding('utf-8') : value
      end
      location
    rescue
      Rails.logger.warn "Geocoding error for '#{name}' @ '#{address}, #{city}': #{$!.message}"
      nil
    end
  end

  def geocoded?
    latitude.present? && longitude.present?
  end

  def update_infractions_cache!
    self.infractions_amount = infractions.sum(:amount)
    self.judgment_span = infractions.maximum(:judgment_date) - infractions.minimum(:judgment_date)
    self.save!
  end

private

  def update_fingerprints
    self.name_fingerprint = name.fingerprint if name_changed?
    self.address_fingerprint = address.fingerprint if address_changed?
    self.city_fingerprint = city.fingerprint if city_changed?
  end
end
