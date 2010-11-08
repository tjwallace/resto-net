class Infraction < ActiveRecord::Base
  belongs_to :establishment, :counter_cache => true

  validates_presence_of :establishment, :amount, :infraction_date, :judgment_date
  validates_numericality_of :amount, :only_integer => true, :greater_than => 0

  translates :description

  after_save :update_infractions_amount!
  after_destroy :update_infractions_amount!

  delegate :update_infractions_amount!, :to => :establishment

  scope :latest, order("judgment_date DESC")
end
