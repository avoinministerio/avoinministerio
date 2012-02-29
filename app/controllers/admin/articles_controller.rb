class Admin::ArticlesController < Admin::AdminController
  include Admin::PublishingActions

  respond_to :html
  
  def index
    @parent = parent_resource
    @articles = resource_scope.all
  end
  
  def show
    @idea = resource.idea
    respond_with resource
  end

  def new
    respond_with @article = resource_scope.build
  end
  
  def create
    @article = resource_scope.build(params[:article])
    @article.save
    respond_with @article, location: [:admin, @article.idea]
  end
      
  private
  
  def resource
    @article ||= resource_scope.find(params[:id])
  end
  
  def parent_resource
    if params[:idea_id]
      Idea.find(params[:idea_id])
    end
  end
    
  def resource_scope
    if params[:idea_id]
      parent_resource.articles
    else
      Article
    end
  end
end
