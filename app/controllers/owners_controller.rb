class OwnersController < ApplicationController
  caches_page :index, :show
  respond_to :json, :xml

  def index
    respond_with Owner.all
  end

  def show
    respond_with Owner.find(params[:id])
  end

end
