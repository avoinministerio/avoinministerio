class ProfilesController < ApplicationController
  def edit
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

end
