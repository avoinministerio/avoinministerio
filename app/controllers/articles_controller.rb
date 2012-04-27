class ArticlesController < ApplicationController
  before_filter :authenticate_citizen!, except: [ :index, :show ]
  
  respond_to :html

  def index
  	@published_blogs = Article.published.where(article_type: "blog").order("created_at DESC")
  	@blogs = @published_blogs.paginate(page: params[:page], per_page: 30)
  end

  def show
    @article = Article.find(params[:id])

    KM.identify(current_citizen)
    KM.push("record", "article read", article_id: @article.id,  article_title: @article.title)  # TODO use permalink title

    respond_with @article
  end
  
end
