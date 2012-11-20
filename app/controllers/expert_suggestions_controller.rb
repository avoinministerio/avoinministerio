class ExpertSuggestionsController < ApplicationController
  before_filter :authenticate_citizen!
  
  respond_to :html

  def new
    @idea = Idea.find(params[:idea_id])
    @expert_suggestion = ExpertSuggestion.new

    respond_with @ideas
  end

  def create
    @idea = Idea.find(params[:idea_id])
    @expert_suggestion = ExpertSuggestion.new(params[:expert_suggestion])
    @expert_suggestion.supporter = current_citizen
    @expert_suggestion.idea = @idea

    respond_to do |format|
      if @expert_suggestion.save
        format.html { redirect_to @expert_suggestion.idea, notice: 'Expert suggestion was successfully created.' }
        format.json { render json: @expert_suggestion, status: :created, location: @expert_suggestion }
      else
        format.html { render action: "new" }
        format.json { render json: @expert_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

end
