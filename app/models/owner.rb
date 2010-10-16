class Owner < ActiveRecord::Base
  has_many :establishments

  validates_presence_of :name
end
