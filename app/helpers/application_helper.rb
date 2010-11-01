module ApplicationHelper
  def stylesheet(*args)
    content_for :head, stylesheet_link_tag(*args)
  end

  def javascript(*args)
    content_for :head, javascript_include_tag(*args)
  end
end
