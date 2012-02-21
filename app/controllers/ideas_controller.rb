class IdeasController < ApplicationController
  before_filter :authenticate_citizen!, except: [ :index, :show ]
  
  respond_to :html
  
  def index
    @ideas = Idea.all
    respond_with @ideas
  end
  
  def show
    @idea = Idea.find(params[:id])
    @vote = Vote.find_by_idea_id_and_citizen_id(@idea.id, current_citizen.id)
    @idea_vote_count          = Vote.count(:conditions => "idea_id = #{@idea.id}")
    @idea_vote_for_count      = Vote.count(:conditions => "idea_id = #{@idea.id} AND option = 1")
    @idea_vote_against_count  = Vote.count(:conditions => "idea_id = #{@idea.id} AND option = 0")
    @colors = ["#4a4", "#a44"]
    @colors.reverse! if @idea_vote_for_count < @idea_vote_against_count

    respond_with @idea, @idea_vote_count, @idea_vote_for_count, @idea_vote_against_count, @colors, @vote
  end
  
  def new
    @idea = Idea.new
    respond_with @idea
  end
  
  def create
    @idea = Idea.new(params[:idea])
    @idea.author = current_citizen
    @idea.state  = "idea"
    flash[:notice] = I18n.t("ideas.created") if @idea.save
    respond_with @idea
  end
  
  def edit
    @idea = Idea.find(params[:id])
    respond_with @idea
  end
  
  def update
    @idea = current_citizen.ideas.find(params[:id])
    flash[:notice] = I18n.t("ideas.updated") if @idea.update_attributes(params[:idea])
    respond_with @idea
  end

  def vote_flow
    # does not work well over SQLite or Postgres, but would be the easiest way around
#    @vote_counts = Vote.find(:all, :select => "idea_id, updated_at, count(option) AS option", :group => "idea_id, datepart(year, updated_at)")
    # thus we need to go through all the ideas, pick votes and group them in memory
    @vote_counts = {}
    Idea.all.each do |idea|
      @vote_counts[idea.id] ||= {}
      Vote.where("idea_id = #{idea.id}").find(:all, :select => "updated_at, option").each do |vote|
        year_week = vote.updated_at.strftime("%Y-%W")
        @vote_counts[idea.id][year_week] ||= {}
        @vote_counts[idea.id][year_week][vote.option] ||= 0
        @vote_counts[idea.id][year_week][vote.option] += 1
      end
    end
    p @vote_counts
    render :layout => 'vote-flow'
  end
end
