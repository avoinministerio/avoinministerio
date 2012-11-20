class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :set_locale_from_url
  before_filter :set_changer

  def after_sign_in_path_for(resource)
      KM.identify(current_citizen)
      KM.push("record", "signed in")
      return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  private

  rescue_from 'Exception' do |exception|
    # log the exception to get a clue what's going wrong
    Rails.logger.fatal formatted_exception(exception)
    Rails.logger.flush

    # re-raise exception in dev and test env to easen debugging
    raise exception unless Rails.env.production?

    case exception
      # 404
      when ActiveRecord::RecordNotFound,
           ActionController::UnknownController,
           ActionController::UnknownAction
        render_404
      # 422
      when ActiveRecord::RecordInvalid,
           ActiveRecord::RecordNotSaved,
           ActionController::InvalidAuthenticityToken
        render_422
      # 500
      else
        render_500
    end
  end

  def formatted_exception(exception)
    "\n\n" + ('#' * 80) + "\n\n" +
    "#{exception.class} (#{exception.message}):\n  " +
    Rails.backtrace_cleaner.clean(exception.backtrace).join("\n  ") +
    "\n\n" + ('#' * 80) + "\n\n"
  end

  [404, 422, 500].each do |code|
    class_eval(<<-EOCODE)
      def render_#{code}
        render 'shared/#{code}', layout: 'error', status: #{code}
        return false
      end
    EOCODE
  end

  def set_locale
    I18n.locale = params[:locale] || ((lang = request.env['HTTP_ACCEPT_LANGUAGE']) && lang[/^[a-z]{2}/])
  end

  def set_changer
    Thread.current[:changer] = current_administrator || current_citizen
  end
end
