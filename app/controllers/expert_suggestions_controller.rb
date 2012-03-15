class ExpertSuggestionsController < ApplicationController
  # GET /expert_suggestions
  # GET /expert_suggestions.json
  def index
    @expert_suggestions = ExpertSuggestion.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @expert_suggestions }
    end
  end

  # GET /expert_suggestions/1
  # GET /expert_suggestions/1.json
  def show
    @expert_suggestion = ExpertSuggestion.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @expert_suggestion }
    end
  end

  # GET /expert_suggestions/new
  # GET /expert_suggestions/new.json
  def new
    @idea = Idea.find(params[:idea_id])
    @expert_suggestion = ExpertSuggestion.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @expert_suggestion }
    end
  end

  # GET /expert_suggestions/1/edit
  def edit
    @expert_suggestion = ExpertSuggestion.find(params[:id])
  end

  # POST /expert_suggestions
  # POST /expert_suggestions.json
  def create
    @idea = Idea.find(params[:expert_suggestion]["idea_id"])
    @expert_suggestion = ExpertSuggestion.new(params[:expert_suggestion].delete_if{|k,v| ["idea_id"].include? k})

    respond_to do |format|
      if @expert_suggestion.save
        format.html { redirect_to @idea, notice: 'Expert suggestion was successfully created.' }
        format.json { render json: @expert_suggestion, status: :created, location: @expert_suggestion }
      else
        format.html { render action: "new" }
        format.json { render json: @expert_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expert_suggestions/1
  # PUT /expert_suggestions/1.json
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

  # DELETE /expert_suggestions/1
  # DELETE /expert_suggestions/1.json
  def destroy
    @expert_suggestion = ExpertSuggestion.find(params[:id])
    @expert_suggestion.destroy

    respond_to do |format|
      format.html { redirect_to expert_suggestions_url }
      format.json { head :ok }
    end
  end
end
