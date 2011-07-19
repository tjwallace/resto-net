task :cron => :environment do
  Rake::Task['data:update'].invoke
end
