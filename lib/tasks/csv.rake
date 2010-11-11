# encoding: utf-8

I18n.locale = :fr

namespace :csv do
  require 'csv'

  desc 'CSV file for infraction counts by establishment'
  task :count => :environment do
    CSV.open('count.csv', 'w') do |csv|
      csv << %w(name infractions_count latitude longitude)
      Establishment.all.each do |e|
        if e.infractions_count > 0
          csv << [ e.name, e.infractions_count, e.latitude, e.longitude ]
        end
      end
    end
  end

  desc 'CSV file for infraction amounts by establishment'
  task :amount => :environment do
    CSV.open('amount.csv', 'w') do |csv|
      csv << %w(name infractions_count latitude longitude)
      Establishment.all.each do |e|
        if e.infractions_amount > 0
          csv << [ e.name, e.infractions_amount, e.latitude, e.longitude ]
        end
      end
    end
  end
end
