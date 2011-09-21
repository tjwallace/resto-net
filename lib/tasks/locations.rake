namespace :locations do

  task :locations => :environment do
    Establishment.limit(80).each do |establishment|
      begin
        response = Yelp.reviews(:term => establishment.name.gsub(/ Inc\.?/i, ''), :location => establishment.full_address)
        if response
          p establishment.full_address
          p response["address1"]
          p "***************"
        end
      rescue
        next
      end
    end
  end
end
