# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :infraction do |f|
  f.establishment nil
  f.description "MyText"
  f.amount 1
  f.infraction_date "2010-10-03"
  f.jugement_date "2010-10-03"
end
