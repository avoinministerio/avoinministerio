class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :set_locale_from_url
  before_filter :set_changer

  def after_sign_in_path_for(resource)
      return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])
  end

  def set_changer
    Thread.current[:changer] = current_citizen || current_administrator
  end
end
