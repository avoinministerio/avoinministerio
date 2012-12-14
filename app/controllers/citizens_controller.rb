class CitizensController < ApplicationController
  before_filter :authenticate_citizen!
  before_filter :fetch_citizen
  
  def edit
  end

  def after_sign_up
  end
  
  # based on https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  def update
    if @citizen.update_with_password(params[:citizen])
      flash[:notice] = I18n.t("registrations.edit.password_updated")
      sign_in @citizen, :bypass => true
    end
    render "edit"
  end

  def touring
    current_citizen.finish_tour(params[:name_of_tour])
    redirect_to root_path
  end
  
  def reset_touring
    current_citizen.reset_tours
    cookies.delete(:old_citizen_idea_tour_end)
    cookies.delete(:old_citizen_idea_tour_current_step)
    cookies.delete(:old_citizen_home_tour_current_step)
    cookies.delete(:old_citizen_home_tour_current_end)
    cookies.delete(:citizen_idea_tour_end)
    cookies.delete(:citizen_idea_tour_step)
    cookies.delete(:citizen_home_tour_end)
    cookies.delete(:citizen_idea_tour_step)
    respond_to do |format|
      format.js   { render action: "reset_successful" }
    end
  end

  private
  
  def fetch_citizen
    @citizen = current_citizen
  end

end
