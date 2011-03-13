# encoding: utf-8

namespace :data do
  require 'data_page'

  desc "Download XML data"
  task :download do
    (2007..Date.today.year).each do |year|
      page = DataPage.new(year)
      unless page.downloaded?
        puts "Downloading #{page.filename}"
        File.open page.filename, 'w' do |f|
          f.write page.content(:remote)
        end
      end
    end
  end

  desc "Import XML data"
  task :import => :environment do
    I18n.locale = :fr
    (2007..Date.today.year).each do |year|
      DataPage.new(year).scan
    end
  end

end
