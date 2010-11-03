class PagesController < ApplicationController
  def home
    @infractions = Infraction.includes(:establishment).latest.limit(10)
    @most_infractions = Establishment.by_most_infractions.limit(10)
    @highest_infractions = Establishment.by_highest_infractions.limit(10)
  end
end
