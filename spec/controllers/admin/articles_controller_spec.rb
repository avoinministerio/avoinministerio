require 'spec_helper'

RSpec::Matchers.define :have_an_article_written_by do |citizen|
  match do |idea|
    for article in idea.articles
      if article.author == citizen
        return true
      end
    end
    return false
  end
end

describe Admin::ArticlesController do
  let (:administrator) {
    Factory(:administrator)
  }
  let (:unsaved_article) {
    Factory.build(:article)
  }
  let (:article_hash) {{
      :article_type => unsaved_article.article_type,
      :title => unsaved_article.title,
      :ingress => unsaved_article.ingress,
      :body => unsaved_article.body,
      :idea_id => unsaved_article.idea.id
    }}
  let (:citizen) {
    Factory(:citizen)
  }

  before :each do
    sign_in :administrator, administrator
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
  
  post :create do
    params {{:article => article_hash}}
    before do
      @article_count = Article.count
      @request.env['HTTP_REFERER'] = new_article_path
    end
    context "with idea ID specified" do
      context "with author name specified like 'John Smith'" do
        params {{:article => article_hash,
            :idea_id => unsaved_article.idea.id,
            :author => citizen.profile.name}}
        it "saves the article" do
          action! do
            its(:response) {should render_template(:create)}
            Article.count.should == @article_count + 1
            idea = unsaved_article.idea
            idea.reload
            idea.should have_an_article_written_by(citizen)
          end
        end
      end
      context "with author name specified like 'Smith, John'" do
        params {{:article => article_hash,
            :idea_id => unsaved_article.idea.id,
            :author => citizen.profile.last_name + ", " +
              citizen.profile.first_name}}
        it "saves the article" do
          action! do
            idea = unsaved_article.idea
            idea.reload
            idea.should have_an_article_written_by(citizen)
          end
        end
      end
      context "with author email address specified instead of the name" do
        params {{:article => article_hash,
            :idea_id => unsaved_article.idea.id,
            :author => citizen.email}}
        it "saves the article" do
          action! do
            idea = unsaved_article.idea
            idea.reload
            idea.should have_an_article_written_by(citizen)
          end
        end
      end
      context "with author name missing" do
        params {{:article => article_hash,
            :idea_id => unsaved_article.idea.id
          }}
        it "does not save the article" do
          action! do
            its(:response) {should be_redirect}
            its(:response) {should redirect_to(new_article_path)}
            Article.count.should == @article_count
            idea = unsaved_article.idea
            idea.reload
            idea.should_not have_an_article_written_by(nil)
          end
        end
      end
      context "with empty author name" do
        params {{:article => article_hash,
            :idea_id => unsaved_article.idea.id,
            :author => ''
          }}
        it "does not save the article" do
          action! do
            Article.count.should == @article_count
          end
        end
      end
      context "with author name that is theoretically valid but absent in the database" do
        params {{:article => article_hash,
            :idea_id => unsaved_article.idea.id,
            :author => "svub rgnvna"
          }}
        it "does not save the article" do
          action! do
            Article.count.should == @article_count
          end
        end
      end
      context "with author email address that is theoretically valid but absent in the database" do
        params {{:article => article_hash,
            :idea_id => unsaved_article.idea.id,
            :author => "gvhj@vkvkkhv.com"
          }}
        it "does not save the article" do
          action! do
            Article.count.should == @article_count
          end
        end
      end
    end
    context "with idea ID missing" do
      params {{:article => article_hash,
          :author => unsaved_article.author.profile.name}}
      it "saves the article" do
        action! do
          idea = unsaved_article.idea
          idea.reload
          idea.should have_an_article_written_by(unsaved_article.author)
        end
      end
    end
  end

end
