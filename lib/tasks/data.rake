# encoding: utf-8

namespace :data do
  require 'data_file'

  desc "Download XML infraction data"
  task :download do
    (2007..Date.today.year).each do |year|
      page = DataFile.new(year)
      if page.downloaded?
        puts "Skipping #{page.filename}"
      else
        puts "Downloading #{page.filename}"
        page.download!
      end
    end
  end

  desc "Import all infractions"
  task :import => :environment do
    I18n.locale = :fr
    (2007..Date.today.year).each do |year|
      DataFile.new(year).scan
    end
  end

  desc "Update infractions"
  task :update => :environment do
    I18n.locale = :fr
    DataFile.new(Date.today.year).scan(:remote)
  end

end
