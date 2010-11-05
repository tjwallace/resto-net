class Owner < ActiveRecord::Base
  has_many :infractions
  has_many :establishments, :through => :infractions, :uniq => true

  validates_presence_of :name
end
