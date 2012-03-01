class IdeasController < ApplicationController
  before_filter :authenticate_citizen!, except: [ :index, :show ]
  
  respond_to :html
  
  def index
    @ideas = Idea.published.all
    respond_with @ideas
  end
  
  def show
    @idea = Idea.includes(:votes).find(params[:id])
    @vote = @idea.votes.by(current_citizen).first if citizen_signed_in?
    
    @idea_vote_for_count      = @idea.vote_counts[1] || 0
    @idea_vote_against_count  = @idea.vote_counts[0] || 0
    @idea_vote_count          = @idea_vote_for_count + @idea_vote_against_count
    
    @colors = ["#8cc63f", "#a9003f"]
    @colors.reverse! if @idea_vote_for_count < @idea_vote_against_count
    
    respond_with @idea
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
    # @vote_counts = Vote.find(:all, :select => "idea_id, updated_at, count(option) AS option", :group => "idea_id, datepart(year, updated_at)")

    # thus we need to go through all the ideas, pick votes and group them in memory
    @vote_counts = {}
    @idea_counts = {}
    Idea.all.each do |idea|
      Vote.where("idea_id = #{idea.id}").find(:all, :select => "updated_at, option").each do |vote|
        @vote_counts[vote.updated_at.beginning_of_week.to_i] ||= {}
        @vote_counts[vote.updated_at.beginning_of_week.to_i][idea.id] ||= {}
        @vote_counts[vote.updated_at.beginning_of_week.to_i][idea.id][vote.option] ||= 0
        @vote_counts[vote.updated_at.beginning_of_week.to_i][idea.id][vote.option] += 1
        @idea_counts[idea.id] ||= {"a"=>0, "d"=>0, "c"=>0, "u" => 0, "n"=> idea.title[0,20]}
        @idea_counts[idea.id]["a"] += 1 if vote.option == 1
        @idea_counts[idea.id]["d"] += 1 if vote.option == 0
        @idea_counts[idea.id]["c"] += 1
      end
    end
    most_popular_ideas = @idea_counts.keys.sort{|a,b| @idea_counts[b]["c"] <=> @idea_counts[a]["c"]}
    # convert vote_counts into impact-style json
    @buckets = @vote_counts.keys.sort.map do |d|
      vcs = most_popular_ideas[0,10].find_all{|i| @vote_counts[d].has_key? i}.map do |idea_id|
        votes = @vote_counts[d][idea_id]
        vote_count = (votes[0] || 0) + (votes[1] || 0)
        [idea_id, vote_count]
      end
      {"d" => d, "i" => vcs.sort{|a,b| b[1] <=> a[1]}}
    end.to_json

    @authors = @idea_counts.to_json

    render 
  end
end
