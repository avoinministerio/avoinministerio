class VoteController < ApplicationController
  before_filter :setup_objects
  before_filter :authenticate_citizen!
  
  def vote
    @idea.vote(current_citizen, params[:vote])
    flash[:notice] = flash_message
    redirect_to @idea
  end

  private
  
  def setup_objects
    @idea = Idea.find(params[:id])
  end
  
  def flash_message
    case params[:vote]
    when "0"
      flash[:notice] = I18n.t("votes.voted_against")
    when "1"
      flash[:notice] = I18n.t("votes.voted_for")
    end
  end
end
