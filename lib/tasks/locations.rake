namespace :locations do

  task :locations => :environment do
    Establishment.all.each do |establishment|
      begin
        response = Yelp.reviews(:term => establishment.name.gsub(/ Inc\.?/i, ''), :location => establishment.full_address)
        if response
          p establishment.full_address
          p establishment.name
          p '------------------'
          p response["address1"]
          p response["name"]
          p "***************"
        else
          p establishment.name
          p establishment.full_address
          p '00000000000000000000000'
        end
      rescue
        next
      end
    end
  end
end
