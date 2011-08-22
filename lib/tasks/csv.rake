I18n.locale = :fr

namespace :csv do
  require 'csv'

  desc 'CSV file for infraction counts by establishment'
  task :count => :environment do
    CSV.open('count.csv', 'w') do |csv|
      csv << %w(name infractions_count latitude longitude)
      Establishment.all.each do |establishment|
        if establishment.infractions_count > 0
          csv << [
            establishment.name,
            establishment.infractions_count,
            establishment.latitude,
            establishment.longitude,
          ]
        end
      end
    end
  end

  desc 'CSV file for infraction amounts by establishment'
  task :amount => :environment do
    CSV.open('amount.csv', 'w') do |csv|
      csv << %w(name infractions_amount latitude longitude)
      Establishment.all.each do |establishment|
        if establishment.infractions_amount > 0
          csv << [
            establishment.name,
            establishment.infractions_amount,
            establishment.latitude,
            establishment.longitude,
          ]
        end
      end
    end
  end
end
