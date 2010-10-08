# encoding: utf-8

namespace :scan do
  require 'scanner'

  desc "Test the scanner"
  task :test do
    pp DataPage.new(1, 2007).scan
  end

  desc "Download HTML files"
  task :download do
    (2007..2010).each do |year|
      (1..12).each do |month|
        url = DataPage.new(month, year).url
        output_file = File.join Rails.root, 'data', sprintf("%d_%02d.html", year, month)
        File.open output_file, 'w' do |f|
          puts "Downloading #{year} - #{month} from #{url}"
          f.write open(url).read
        end unless File.exists? output_file
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
          establishment = owner.establishments.find_or_create_by_name est_data[:name]
          establishment.address ||= est_data[:address]
          establishment.type ||= Type.find_first_by_name(est_data[:type]) || Type.create(:name => est_data[:type])

          est_data[:infractions].each do |inf_data|
            establishment.infractions.create inf_data
          end

          establishment.save
        end
      end
    end
  end

end
