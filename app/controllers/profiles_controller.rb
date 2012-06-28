class ProfilesController < ApplicationController
  
  before_filter :fetch_objects
  
  def fetch_objects
    if current_citizen
      @citizen = current_citizen
      @profile = current_citizen.profile
      @voted_ideas = Vote.by(current_citizen).map {|v| v.idea}
      @commented_ideas = current_citizen.comments.map do |comment|
        if comment.commentable_type == "Idea"
          comment.commentable
        end
      end.uniq
    else
      redirect_to :back
    end
  end
  
  def edit
    
  end
  
  def update
    if @citizen.update_attributes(params[:citizen])
      flash[:notice] = I18n.t("settings.updated")
    end
    render "edit"
  end
  
  # based on https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-edit-their-password
  def update_password
    if @citizen.update_with_password(params[:citizen])
      flash[:notice] = I18n.t("registrations.edit.password_updated")
      sign_in @citizen, :bypass => true
    end
    render "edit"
  end

end
