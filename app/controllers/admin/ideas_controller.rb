class Admin::IdeasController < Admin::AdminController
  respond_to :html
  
  before_filter :get_idea, except: :index
  
  def index
    respond_with @ideas = Idea.all
  end
  
  def show
    respond_with @idea
  end
  
  def publish
    @idea.publish!
    respond_with @idea
  end
  
  def unpublish
    @idea.unpublish!
    respond_with @idea
  end
  
  private
  
  def get_idea
    @idea = Idea.find(params[:id])
  end
end
