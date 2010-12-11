class OwnersController < ApplicationController
  caches_action :index, :cache_path => Proc.new{ |c| c.params }
  caches_page :show

  respond_to :json, :xml

  def index
    respond_with Owner.search(params[:search])
  end

  def show
    respond_with Owner.find(params[:id])
  end
end
