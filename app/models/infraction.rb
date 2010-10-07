class Infraction < ActiveRecord::Base
  belongs_to :establishment

  translates :description
end
