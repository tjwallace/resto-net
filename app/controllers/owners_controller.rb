class OwnersController < ApplicationController
  caches_action :index, :cache_path => Proc.new{ |c| c.params }
  caches_page :show

  respond_to :json, :xml

  def index
    @owners = Owner.scoped
    @owners = Owner.search(params[:search]) if params[:search].present?
    respond_with @owners
  end

  def show
    respond_with Owner.find(params[:id]), :include => :infractions
  end
end
