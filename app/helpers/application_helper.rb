module ApplicationHelper
  def stylesheet(*args)
    content_for :head, stylesheet_link_tag(*args)
  end

  def javascript(*args)
    content_for :head, javascript_include_tag(*args)
  end

  # railscasts episode 228
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    new_params = {:sort => column, :direction => direction}
    new_params.merge!(:search => params[:search]) if searching?
    link_to title, new_params, {:class => css_class}
  end
end
