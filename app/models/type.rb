class Type < ActiveRecord::Base
  has_many :establishments

  validates_presence_of :name

  # Rails dynamic finder doesn't exist as name is not on Type model. Globalize3
  # dynamic finders do not follow Rails convention.
  def self.find_or_create_by_name(name)
    find_first_by_name(name) || create(:name => name)
  end
end
