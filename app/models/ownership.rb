class Ownership < ActiveRecord::Base
  belongs_to :owner, :counter_cache => :establishments_count
  belongs_to :establishment, :counter_cache => :owners_count

  validates_presence_of :owner, :establishment
end
