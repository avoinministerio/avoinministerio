class Admin::IdeasController < Admin::AdminController
  include Admin::PublishingActions
  
  respond_to :html

  def index
    respond_with @ideas = Idea.paginate(page: params[:page])
  end
  
  def show
    respond_with resource
  end

  def edit
    @idea = Idea.find(params[:id])
    respond_with @idea
  end
  
  def update
    @idea = Idea.find(params[:id])
    if @idea.update_attributes(params[:idea])
      flash[:notice] = I18n.t("idea.updated") 
      KM.identify(current_citizen)
      KM.push("record", "admin idea edited", idea_id: @idea.id,  idea_title: @idea.title)  # TODO use permalink title
    end
    respond_with @idea
  end

  
  private

  def resource
    @idea ||= Idea.find(params[:id])
  end
end
