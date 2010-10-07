namespace :scan do

  desc "Test the scanner"
  task :test do
    require 'scanner'
    DataPage.new(2, 2009).scan
  end

  desc "Download HTML files"
  task :download do
    require 'scanner'
    (2006..2010).each do |year|
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

end
