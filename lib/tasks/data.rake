namespace :data do
  require 'data_file'

  desc "Download XML infraction data"
  task :download => :environment do
    DataFile.new.download
  end

  desc "Import all infractions"
  task :import => :environment do
    I18n.locale = :fr
    DataFile.new.scan
  end

  desc "Update infractions"
  task :update => :environment do
    I18n.locale = :fr
    DataFile.new.scan(:remote)
  end
end
