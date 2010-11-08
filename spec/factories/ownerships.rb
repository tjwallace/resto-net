# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :ownership do |f|
  f.owner_id 1
  f.establishment_id 1
  f.start_date "2010-11-07"
  f.end_date "2010-11-07"
end
