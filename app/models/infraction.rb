class Infraction < ActiveRecord::Base
  belongs_to :establishment, :counter_cache => true
  belongs_to :owner, :counter_cache => true

  attr_accessible :owner_id, :establishment_id, :description, :infraction_date,
    :judgment_date, :amount

  validates_presence_of :owner_id, :establishment_id, :description,
    :infraction_date, :judgment_date, :amount
  validates_numericality_of :amount, :only_integer => true, :greater_than => 0

  after_save :update_infractions_cache!
  after_destroy :update_infractions_cache!
  delegate :update_infractions_cache!, :to => :establishment
end
