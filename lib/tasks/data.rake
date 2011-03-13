# encoding: utf-8

namespace :data do
  require 'data_page'

  desc "Download xml files"
  task :download do
    (2007..2011).each do |year|
      page = DataPage.new(year)
      unless page.downloaded?
        puts "Downloading #{year}"
        File.open page.filename, 'w' do |f|
          f.write page.content(:remote)
        end
      end
    end
  end

  desc "Import data"
  task :import => :environment do
    I18n.locale = :fr
    (2007..2011).each do |year|
      page = DataPage.new year
      page.scan
    end
  end

end
