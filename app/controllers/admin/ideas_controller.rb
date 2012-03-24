class Admin::IdeasController < Admin::AdminController
  include Admin::PublishingActions
  
  respond_to :html

  def index
    respond_with @ideas = Idea.paginate(page: params[:page])
  end
  
  def show
    respond_with resource
  end
  
  private

  def resource
    @idea ||= Idea.find(params[:id])
  end
end
