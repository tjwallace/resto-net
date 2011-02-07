module MapHelper
  # icons from http://code.google.com/p/google-maps-icons/
  def establishments_json(establishments)
    establishments.select{ |e| e.geocoded? }.map do |e|
      i = e.infractions.latest.first
      {
        :id => e.id,
        :lat => e.latitude,
        :lng => e.longitude,
        :name => e.name,
        :url => url_for(e),
        :icon => "http://google-maps-icons.googlecode.com/files/red%02d.png" % [e.infractions_count],
        :infractions_desc => "#{t :total_infractions}: #{number_to_currency e.infractions_amount} (#{e.infractions_count})",
        :latest_infraction => "#{t :latest_infraction}: #{l i.judgment_date} (#{number_to_currency i.amount})"
      }
    end.to_json
  end
end
