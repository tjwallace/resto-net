class EstablishmentsController < ApplicationController
  caches_page :show
  helper_method :sort_column, :sort_direction, :searching?

  def index
    establishments = Establishment.scoped
    establishments = establishments.includes(:infractions) if sort_column == "infractions.judgment_date"
    @establishments = establishments.search(params['search']).order(sort_column + " " + sort_direction).paginate(:per_page => 20, :page => params[:page])
  end

  def show
    @establishment = Establishment.includes(:infractions => [:translations]).find params['id']
    @infractions = @establishment.infractions.includes(:owner).latest
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

  def searching?
    params[:search] && params[:search].size > 0
  end
end
