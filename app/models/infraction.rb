class Infraction < ActiveRecord::Base
  belongs_to :establishment

  validates_presence_of :establishment, :amount, :infraction_date, :judgment_date
  validates_numericality_of :amount, :only_integer => true, :greater_than => 0

  translates :description
end
