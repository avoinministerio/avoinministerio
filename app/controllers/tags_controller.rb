class TagsController < ApplicationController
  def index
    @tags = Tag.order(:name)
    respond_to do |format|
      format.html
      format.json { render json: @tags.tokens(params[:q]) }
    end
  end

  def vote_for
    @vote = TagVote.where(:idea_id => params[:idea_id], :tag_id => params[:tag_id], :citizen_id => params[:citizen_id]).first
    if @vote == nil
      Tag.vote_for(params[:idea_id], params[:tag_id], params[:citizen_id])
      respond_vote_js
    else
      check_and_change_vote
      respond_vote_js
    end
  end

  def vote_against
    @vote = TagVote.where(:idea_id => params[:idea_id], :tag_id => params[:tag_id], :citizen_id => params[:citizen_id]).first
    if @vote == nil
      Tag.vote_against(params[:idea_id], params[:tag_id], params[:citizen_id])
      respond_vote_js
    else
      check_and_change_vote
      respond_vote_js
    end
  end

  def add_to_suggested
    @idea = Idea.find(params[:id])
    @tag = Tag.find(params[:tag_id])
    respond_to do |format|
      format.js   { render action: :add_to_suggested, :locals => { :tag => @tag, :idea => @idea } }
    end
  end

  def list_of_suggested
    @idea = Idea.find(params[:id])
    respond_to do |format|
      format.js   { render action: :list_of_suggested, :locals => { :idea => @idea } }
    end
  end

  def show_more
    @idea = Idea.find(params[:id])
    respond_to do |format|
      format.js { render action: :show_more, :locals => { :idea => @idea } }
    end
  end

  private

  def respond_vote_js
    @idea = Idea.find(params[:idea_id])
    @tag = Tag.find(params[:tag_id])
    respond_to do |format|
      format.js   { render action: :citizen_voted, :locals => { :idea => @idea, :tag => @tag } }
    end
  end

  def check_and_change_vote
    if @vote.voted == "for"
      Tagging.where(:tag_id => params[:tag_id], :idea_id => params[:idea_id]).all.first.decrease_score
      @vote.update_attributes(:voted => 'against')
    else
      Tagging.where(:tag_id => params[:tag_id], :idea_id => params[:idea_id]).all.first.increase_score
      @vote.update_attributes(:voted => 'for')
    end
  end
end