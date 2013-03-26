class TranslatedIdeasController < ApplicationController
  before_filter :authenticate_citizen!, except: [:show]

  respond_to :html

  def index
    @translated_ideas = TranslatedIdea.find_all_by_idea_id(params[:idea_id])
  end

	def create
    @translated_idea = TranslatedIdea.create(params[:translated_idea])
    @translated_idea.author = current_citizen
    if @translated_idea.save
      redirect_to idea_translated_idea_path(params[:idea_id], @translated_idea)
    else
      @similar_idea = TranslatedIdea.where(idea_id: params[:translated_idea][:idea_id], language: params[:translated_idea][:language]).all.first
      redirect_to idea_translated_idea_path(params[:idea_id], @similar_idea)
    end
  end

  def new
    @translated_idea = TranslatedIdea.new
    @idea = Idea.find(params[:idea_id])
  end

  def show
    @translated_idea = TranslatedIdea.find(params[:id])
    @idea = Idea.find(@translated_idea.idea_id)
  end

  def edit
    @translated_idea = TranslatedIdea.find(params[:id])
    @idea = Idea.find(@translated_idea.idea_id)
  end

  def update
    @translated_idea = TranslatedIdea.find(params[:id])
    if @translated_idea.update_attributes(params[:translated_idea])
      flash[:notice] = I18n.t("idea.updated") 
    end
    redirect_to idea_translated_idea_path(params[:idea_id], @translated_idea)
  end
end
