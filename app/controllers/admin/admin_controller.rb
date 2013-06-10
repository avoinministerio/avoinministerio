class Admin::AdminController < ApplicationController
  include Admin::AdminHelper
  
  layout "admin"
  
  before_filter :authenticate_administrator!
  before_filter :current_location
  
  private
  def current_location
    if session[:current_city]
      @current_location = session[:current_city]
    else
      redirect_to select_location_admin_states_path
    end
  end
end