# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :establishment do |f|
  f.sequence(:name) { |n| "establishment #{n}" }
  f.sequence(:address) { |n| "try and geocode address #{n}" }
  f.sequence(:city) { |n| "try and geocode city #{n}" }
  f.association :type
end
