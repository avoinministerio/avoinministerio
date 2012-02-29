class ArticlesController < ApplicationController
  before_filter :authenticate_citizen!, except: [ :index, :show ]
  
  respond_to :html

  def show
    @article = Article.find(params[:id])

    respond_with @article
  end
  
end
