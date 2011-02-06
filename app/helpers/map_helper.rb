module MapHelper
  def establishments_json(establishments)
    establishments.select{ |e| e.geocoded? }.map do |estab|
      {
        :id => estab.id,
        :name => estab.name,
        :url => url_for(estab),
        :count => "%02d" % [estab.infractions_count],
        :infractions_desc => "#{t :total_infractions}: #{number_to_currency estab.infractions_amount} (#{estab.infractions_count})",
        :address => "#{t :address}: #{estab.full_address}",
        :lat => estab.latitude,
        :lng => estab.longitude
      }
    end.to_json
  end
end
