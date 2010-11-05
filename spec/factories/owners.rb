# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :owner do |f|
  f.sequence(:name) { |n| "owner #{n}" }
end
