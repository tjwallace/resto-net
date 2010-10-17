# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :infraction do |f|
  f.description "infraction description"
  f.amount Random.new.rand(500..3000)
  f.infraction_date Date.today
  f.judgment_date Date.today
end

Factory.define :associated_infraction, :parent => :infraction do |f|
  f.association :establishment
end
