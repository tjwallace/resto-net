class Establishment < ActiveRecord::Base
  belongs_to :type
  has_many :infractions, :dependent => :destroy

  validates_presence_of :name, :address, :type
  validates_uniqueness_of :name

  before_create :geocode

  def geocode
    @@geocoder ||= Graticule.service(:google).new APP_CONFIG['gmaps_api_key']

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

  def total_infractions_amount
    infractions.sum(:amount)
  end
end
