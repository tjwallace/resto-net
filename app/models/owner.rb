class Owner < ActiveRecord::Base
  has_many :infractions
  has_many :establishments,
    :through => :infractions,
    :uniq => true

  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name

  before_save :update_fingerprint

  def self.find_or_create_by_name(name)
    find_or_create_by_name_fingerprint name.fingerprint, :name => name
  end

private

  def update_fingerprint
    self.name_fingerprint = name.fingerprint if name_changed?
  end
end
