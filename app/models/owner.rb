class Owner < ActiveRecord::Base
  has_many :ownerships
  has_many :establishments, :through => :ownerships

  validates_presence_of :name
end
