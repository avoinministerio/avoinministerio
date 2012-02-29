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
    redirect_to [:admin, @idea]
  end
  
  def unpublish
    @idea.unpublish!
    redirect_to [:admin, @idea]
  end
  
  def moderate
    @idea.moderate!
    redirect_to [:admin, @idea]
  end
  
  private
  
  def get_idea
    @idea = Idea.find(params[:id])
  end
end
