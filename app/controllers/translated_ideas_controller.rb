class TranslatedIdeasController < ApplicationController
	def create
    @translated_idea = TranslatedIdea.create(params[:translated_idea])
    @translated_idea.author = current_citizen
    if @translated_idea.save
      redirect_to @translated_idea
    else
      @similar_idea = TranslatedIdea.where(idea_id: params[:translated_idea][:idea_id], language: params[:translated_idea][:language]).all.first
      redirect_to @similar_idea
    end
  end

  def new
    @translated_idea = TranslatedIdea.new
    @idea = Idea.find(params[:idea_id])
  end

  def show
    @idea = TranslatedIdea.find(params[:id])
  end
end
