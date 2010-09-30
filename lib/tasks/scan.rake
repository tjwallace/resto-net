namespace :scan do
  desc "Test the scanner"
  task :test => :environment do
    require 'scanner'
    DataPage.new(2, 2009).scan
  end
end
