class VoteController < ApplicationController
  def vote(option)
    idea = Idea.find(params[:idea])
    vote = Vote.new(idea: idea, citizen: current_citizen, option: option)
    vote = Vote.find_or_create_by_idea_id_and_citizen_id(idea: idea, citizen: current_citizen)
    if vote.option == option
      # no update, no need to save either
      puts "no update, no need to save either"
    else
      vote.option = option
      flash[:notice] = I18n.t("votes.created") if vote.save
    end
    redirect_to :back
  end
  def vote_for
    vote(1)
  end

  def vote_against
    vote(0)
  end

end
