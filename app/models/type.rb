class Type < ActiveRecord::Base
  has_many :establishments

  validates_presence_of :name

  translates :name

  def self.find_or_create_by_name(name)
    self.find_by_name(name) || self.create(:name => name)
  end
end
