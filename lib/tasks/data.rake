# encoding: utf-8

namespace :data do
  require 'data_page'

  desc "Download XML infraction data"
  task :download do
    (2007..Date.today.year).each do |year|
      page = DataPage.new(year)
      if page.downloaded?
        puts "Skipping #{page.filename}"
      else
        puts "Downloading #{page.filename}"
        File.open page.filename, 'w' do |f|
          f.write page.content(:remote)
        end
      end
    end
  end

  desc "Import all infractions"
  task :import => :environment do
    I18n.locale = :fr
    (2007..Date.today.year).each do |year|
      DataPage.new(year).scan
    end
  end

  desc "Update infractions"
  task :update => :environment do
    I18n.locale = :fr
    DataPage.new(Date.today.year).scan(:remote)
  end

end
