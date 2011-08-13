class Establishment < ActiveRecord::Base
  belongs_to :type
  has_many :infractions, :dependent => :destroy, :after_remove => :update_infractions_amount!
  has_many :owners, :through => :infractions, :uniq => true

  validates_presence_of :name, :address, :type
  validates_uniqueness_of :address, :scope => :name

  has_friendly_id :name, :use_slug => true

  before_create :geocode

  scope :geocoded, where("latitude IS NOT NULL", "longitude IS NOT NULL")
  scope :by_most_infractions, order("infractions_count DESC")
  scope :by_highest_infractions, order("infractions_amount DESC")
  scope :by_judgment_date, includes(:infractions).order("infractions.judgment_date DESC")

  def self.search(search)
    search ? where("name LIKE ?", "%#{search}%") : scoped
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
      address
    end
  end

  def geocode
    @@geocoder ||= Graticule.service(:google).new 'ABQIAAAACjg5EelPDHaItWLh83iDnxSTO_huFvQjFKOycbqUllPdGQkbfRRbpq18tH_FX8TyWWBPGwtlKiXNdA'

    begin
      location = @@geocoder.locate address
      %w(latitude longitude street region locality country postal_code).each do |attr|
        value = location.send(attr)
        self[attr] = value.is_a?(String) ? value.force_encoding('utf-8') : value
      end
      return location
    rescue
      Rails.logger.warn "Geocoding error for '#{name}' @ '#{address}': #{$!.message}"
      return nil
    end
  end

  def geocode!
    geocode && save!
  end

  def geocoded?
    !!(latitude && longitude)
  end

  def update_infractions_amount!
    update_attributes :infractions_amount => infractions.sum(:amount), :judgment_span => infractions.maximum(:judgment_date) - infractions.minimum(:judgment_date)
  end
end
