class IdeasController < ApplicationController
  before_filter :authenticate_citizen!, except: [ :index, :show ]
  
  respond_to :html
  
  def index
    @ideas = Idea.all
    respond_with @ideas
  end
  
  def show
    @idea = Idea.find(params[:id])
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
end
