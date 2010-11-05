# encoding: utf-8

namespace :data do
  require 'data_page'

  desc "Test the scanner"
  task :test, :month, :year do |t, args|
    args.with_defaults(:month => 1, :year => 2007)
    pp DataPage.new(args[:month].to_i, args[:year].to_i).scan
  end

  desc "Download HTML files"
  task :download do
    (2007..2010).each do |year|
      (1..12).each do |month|
        page = DataPage.new(month, year)
        File.open page.filename, 'w' do |f|
          puts "Downloading #{year} - #{month} from #{page.url}"
          f.write open(page.url).read
        end unless File.exists? page.filename
      end
    end
  end

  desc "Import data"
  task :import => :environment do
    I18n.locale = :fr
    Dir[ File.join(Rails.root, 'data', '*.html') ].each do |file|
      if file =~ /(\d{4})_(\d{2}).html/
        puts "Importing #{$1} - #{$2}"
        DataPage.new($2.to_i, $1.to_i).scan.each do |data|
          owner = Owner.find_or_create_by_name data[:owner]

          establishment = Establishment.find_or_create_by_name data[:name],
            :address => data[:address],
            :type_id => Type.find_or_create_by_name(data[:type]).id

          data[:infractions].each do |infraction|
            establishment.infractions.create infraction.merge(:owner_id => owner.id)
          end
        end
      end
    end
  end

end
