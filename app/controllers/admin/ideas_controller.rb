class Admin::IdeasController < Admin::AdminController
  include Admin::PublishingActions
  
  respond_to :html

  def index
    respond_with @ideas = Idea.all
  end
  
  def show
    respond_with resource
  end
  
  private

  def resource
    @idea ||= Idea.find(params[:id])
  end
end
