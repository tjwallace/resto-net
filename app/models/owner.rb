class Owner < ActiveRecord::Base
  has_many :establishments, :dependent => :destroy

  validates_presence_of :name
end
