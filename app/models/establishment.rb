class Establishment < ActiveRecord::Base
  belongs_to :type
  has_many :infractions
end
