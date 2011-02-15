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
        :count => e.infractions_count,
        :amount => number_to_currency(e.infractions_amount),
        :latest => {
          :date => l(i.judgment_date),
          :amount => number_to_currency(i.amount)
        }
      }
    end.to_json
  end

  def map_translations_json
    {
      :total_infractions => t(:total_infractions),
      :latest_infraction => t(:latest_infraction)
    }.to_json
  end
end
