require 'spec_helper'

describe ArticlesController do
  render_views

  describe "#show" do
    before :each do
      @article = Factory :article
    end

    it "should show an article" do
      get :show, id: @article.id
      response.body.should include(@article.title)
      response.body.should include(@article.author.name)
      response.body.should include("Article body")
    end

    it "should show an article with slugged url" do
      get :show, id: "#{@article.id}-#{@article.slug}"
      response.body.should include(@article.title)
      response.body.should include(@article.author.name)
      response.body.should include("Article body")
    end
  end
end
