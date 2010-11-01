class EstablishmentsController < ApplicationController
  def index
    @by_count = Establishment.order('infractions_count DESC').limit(10)
    @by_amount = Establishment.order('infractions_amount DESC').limit(10)
  end

  def show
    @establishment = Establishment.find params['id']
  end
end
