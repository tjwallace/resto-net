class EstablishmentsController < ApplicationController
  caches_action :index, :cache_path => Proc.new{ |c| c.params }
  caches_page :show

  respond_to :html, :json, :xml

  helper_method :sort_column, :sort_direction

  def index
    @establishments = Establishment.search(params['search']).order(sort_column + " " + sort_direction)
    @establishments = @establishments.includes(:infractions) if sort_column == "infractions.judgment_date"
    @establishments = @establishments.paginate(:per_page => 20, :page => params[:page]) unless %w(json xml).include?(params[:format])
    respond_with @establishments
  end

  def show
    @establishment = Establishment.includes(:infractions => [:translations]).find(params['id'])
    respond_with @establishment, :include => :infractions
  end

  private

  def sort_column
    %w(name infractions_count infractions_amount infractions.judgment_date).include?(params[:sort]) ? params[:sort] : "name"
  end

  def sort_direction
    if sort_column == "infractions.judgment_date"
      "desc"
    else
      %w(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
    end
  end
end
