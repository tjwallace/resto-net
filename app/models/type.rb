class Type < ActiveRecord::Base
  has_many :establishments

  translates :name
end
