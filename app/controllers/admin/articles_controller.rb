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
    respond_with @article = build_article
  end
  
  def create
    @article = build_article
    @article.save
    respond_with @article, location: article_return_location
  end

  def edit
    @article = Article.find(params[:id])

    respond_with @article
  end

  def update
    @article = Article.find(params[:id])
    flash[:notice] = I18n.t("articles.updated") if @article.update_attributes(params[:article])
    respond_with @article
  end

  private

  def article_return_location
    if parent_resource
      [:admin, @article.idea]
    else
      [:admin, :articles]
    end
  end

  def build_article
    if parent_resource
      resource_scope.build(params[:article])
    else
      resource_scope.new(params[:article])
    end
  end
  
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
