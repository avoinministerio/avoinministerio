class ExpertSuggestionsController < ApplicationController
  before_filter :authenticate_citizen! #, except: [ :index, :show ]
  
  respond_to :html

  def index
    @expert_suggestions = ExpertSuggestion.all

    respond_with @ideas
  end

  def show
    @expert_suggestion = ExpertSuggestion.find(params[:id])

    respond_with @ideas
  end

  def new
    @idea = Idea.find(params[:idea_id])
    @expert_suggestion = ExpertSuggestion.new

    respond_with @ideas
  end

  def edit
    @expert_suggestion = ExpertSuggestion.find(params[:id])
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

  def update
    @expert_suggestion = ExpertSuggestion.find(params[:id])

    respond_to do |format|
      if @expert_suggestion.update_attributes(params[:expert_suggestion])
        format.html { redirect_to @expert_suggestion, notice: 'Expert suggestion was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @expert_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expert_suggestion = ExpertSuggestion.find(params[:id])
    @expert_suggestion.destroy

    respond_with @ideas
  end
end
