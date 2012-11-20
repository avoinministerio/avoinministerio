class VoteController < ApplicationController
  before_filter :setup_objects
  before_filter :authenticate_citizen!
  
  def vote
    KM.identify(current_citizen)
    KM.push("record", "voted", {option: params[:vote], idea: @idea.id})
    vote = @idea.votes.by(current_citizen).first
    if vote
      KM.push("record", "vote change of mind",
              {option: params[:vote], idea: @idea.id})
    else
      KM.push("record", "first vote on idea",
              {option: params[:vote], idea: @idea.id})
    end
    
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
