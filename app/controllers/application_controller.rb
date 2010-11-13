class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || cookies[:locale]
    cookies[:locale] = I18n.locale unless cookies[:locale] == I18n.locale
  end
end
