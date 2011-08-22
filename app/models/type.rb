class Type < ActiveRecord::Base
  has_many :establishments

  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name
end
