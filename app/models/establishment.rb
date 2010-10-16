class Establishment < ActiveRecord::Base
  belongs_to :owner
  belongs_to :type
  has_many :infractions

  validates_presence_of :name, :address, :owner, :type

  after_create :geocode!

  def geocode!
    return if address.nil?

    @@geocoder ||= Graticule.service(:google).new API_KEY

    begin
      location = @@geocoder.locate address
      %w(latitude longitude street region locality country postal_code).each do |attr|
        value = location.send(attr)
        self[attr] = value.is_a? String ? value.force_encoding('utf-8') : value
      end
    rescue
      Rails.logger.warn "Geocoding error for '#{name}' @ '#{address}': #{$!.message}"
    end
  end

  def geocoded?
    latitude && longitude
  end
end
