class EstablishmentsController < ApplicationController
  def index
    @establishments = Establishment.order('name ASC').paginate :page => params[:page]
  end
end
