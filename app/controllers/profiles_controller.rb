class ProfilesController < ApplicationController
  
  before_filter :authenticate_citizen!
  before_filter :fetch_objects
  
  def show
    
  end
  
  def edit
    
  end
  
  def update
    if @profile.update_attributes(params[:profile])
      flash[:notice] = I18n.t("settings.updated")
    end
    render "edit"
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
