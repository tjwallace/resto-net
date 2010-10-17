# encoding: utf-8

namespace :data do
  require 'data_page'

  desc "Test the scanner"
  task :test, :month, :year do |t, args|
    args.with_defaults(:month => 1, :year => 2007)
    pp DataPage.new(args[:month], args[:year]).scan
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
        DataPage.new($2.to_i, $1.to_i).scan.each do |est_data|
          owner = Owner.find_or_create_by_name est_data[:owner]

          establishment = owner.establishments.find_by_name(est_data[:name]) || owner.establishments.create({
            :name    => est_data[:name],
            :address => est_data[:address],
            :type_id => Type.find_or_create_by_name(est_data[:type]).id
          })

          est_data[:infractions].each do |inf_data|
            establishment.infractions.create inf_data
          end
        end
      end
    end
  end

end
