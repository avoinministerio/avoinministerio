class ArticlesController < ApplicationController
  before_filter :authenticate_citizen!, except: [ :index, :show ]
  
  respond_to :html

  def index
    article_type = params[:article_type] || "blog"
    @article_type_heading = {
      "blog"            => "Blogikirjoitukset",
      "statement"       => "Lausunnot",
      # no other types needed at the moment
    }[article_type]
    @published_blogs = Article.published.where(article_type: article_type).order("created_at DESC")
    @blogs = @published_blogs.paginate(page: params[:page], per_page: 15)
  end

  def show
    @article = Article.find(params[:id])

    KM.identify(current_citizen)
    KM.push("record", "article read", article_id: @article.id,  article_title: @article.title)  # TODO use permalink title

    respond_with @article
  end
  
end
