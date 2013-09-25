class ProfilesController < ApplicationController
  before_filter :authenticate_citizen!
  before_filter :fetch_objects

  skip_before_filter :current_location, :only => [:select_location, :set_your_location]
  skip_before_filter :authenticate_citizen!, :only => [:select_location, :set_your_location]
  skip_before_filter :fetch_objects, :only => [:select_location, :set_your_location]

  def show

  end

  def edit

  end

  def update
    params[:profile][:city_id] = params[:city_id]
    if @profile.update_attributes(params[:profile])
      flash[:notice] = I18n.t("settings.updated")
    end
    if current_citizen.sign_in_count == 1
      flash[:success] = "Profile was updated successfully"
      redirect_to citizens_after_sign_up_fi_path
    else
      render "edit"
    end
  end

  def set_your_location
    begin
      if params[:city_id]
        if current_citizen
          current_citizen.profile.update_attribute(:city_id, params[:city_id])
        else
          cookies[:city_id] = params[:city_id]
        end

        redirect_to root_path
      else
        raise
      end
    rescue
      flash[:error] = 'Please select state/city'
      redirect_to select_location_profile_path
    end
  end

  private

  def fetch_objects
    @profile = current_citizen.profile
    @voted_ideas = Vote.by(current_citizen).map {|v| v.idea}
    @commented_ideas = current_citizen.comments.map do |comment|
      if comment.commentable_type == "Idea"
        comment.commentable
      end
    end.uniq
  end

end
