class Type < ActiveRecord::Base
  has_many :establishments

  validates_presence_of :name

  translates :name
end
