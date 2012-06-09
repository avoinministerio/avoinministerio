class Admin::ArticlesController < Admin::AdminController
  include Admin::PublishingActions

  respond_to :html
  
  def index
    @parent = parent_resource
    @blogs      = resource_scope.where(article_type: "blog").all
    @statements = resource_scope.where(article_type: "statement").all
    @footers    = resource_scope.where(article_type: "footer").all
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
    begin
      set_author
      @article.save
      respond_with @article, location: article_return_location
    rescue
      flash[:error] = I18n.t("activerecord.errors.models.citizen.not_found")
      redirect_to :back
    end
  end

  def edit
    @article = Article.find(params[:id])

    respond_with @article
  end

  def update
    @article = Article.find(params[:id])
    begin
      set_author
      flash[:notice] = I18n.t("articles.updated") if @article.update_attributes(params[:article])
      respond_with [:admin, @article]
    rescue
      flash[:error] = I18n.t("activerecord.errors.models.citizen.not_found")
      redirect_to :back
    end
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
  
  def find_citizen_by_name(name)
    if name.include? ","
      name_array = name.split(", ").reverse
    else
      name_array = name.split
    end
    if name_array.length != 2
      raise "invalid name"
    else
      Profile.where(:first_name => name_array[0],
        :last_name => name_array[1]).first.citizen
    end
  end
  
  def set_author
    if params[:author].include? "@"
      @article.author = Citizen.where(:email => params[:author]).first
    else
      @article.author = find_citizen_by_name(params[:author])
    end
  end
end
