class CitizensController < ApplicationController
  before_filter :authenticate_citizen!
  before_filter :fetch_citizen
  
  def edit
  end
  
  # based on https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  def update
    if @citizen.update_with_password(params[:citizen])
      flash[:notice] = I18n.t("registrations.edit.password_updated")
      sign_in @citizen, :bypass => true
    end
    render "edit"
  end
  
  private
  
  def fetch_citizen
    @citizen = current_citizen
  end

end
