# encoding: utf-8
require 'spec_helper'

describe PagesController do
  describe "#home" do
    it "should be successful" do
      get :home
      response.should be_success
    end

    describe "drafts section" do
      before :each do
        @recent_draft = Factory(:idea, state: 'draft')
        @recent_idea = Factory(:idea, state: 'idea')
      end

      it "should include only drafts to drafts section" do
        get :home
        assigns(:drafts).should include(@recent_draft)
        assigns(:drafts).should_not include(@recent_idea)
      end

      it "should calculate vote counts for a draft" do
        # 7 votes for and 4 votes against the idea
        7.times { Factory(:vote, idea: @recent_draft, option: 1) }
        4.times { Factory(:vote, idea: @recent_draft, option: 0) }

        # let's also create a draft without votes yet
        voteless_draft = Factory(:idea, state: 'draft')

        get :home

        assigns(:draft_counts)[@recent_draft.id].should == [7.0/11, '64%', 4.0/11, '36%']
        assigns(:draft_counts)[voteless_draft.id].should == [0.0, ' 0%', 0.0, ' 0%']
      end
    end

    describe "ideas section" do
      before :each do
        @recent_idea = Factory(:idea, state: 'idea')
        @recent_draft = Factory(:idea, state: 'draft')
      end

      it "should include only ideas in state 'idea' to ideas section" do
        get :home
        assigns(:ideas).should include(@recent_idea)
        assigns(:ideas).should_not include(@recent_draft)
      end

      it "should calculate vote counts for an idea" do
        # 1 vote for and 7 votes against the idea
        1.times { Factory(:vote, idea: @recent_idea, option: 1) }
        7.times { Factory(:vote, idea: @recent_idea, option: 0) }

        # let's also create an idea without votes yet
        voteless_idea = Factory(:idea, state: 'idea')

        get :home

        assigns(:idea_counts)[@recent_idea.id].should == ['12%', '88%', 0, '8']
        assigns(:idea_counts)[voteless_idea.id].should == ['0%', '0%', 0, 0]
      end

      it "should include comments count" do
        3.times { Factory(:comment, commentable: @recent_idea) }
        another_idea = Factory(:idea, state: 'idea')
        Factory(:comment, commentable: another_idea)

        get :home

        assigns(:idea_counts)[@recent_idea.id].should == ['0%', '0%', 3, 0]
        assigns(:idea_counts)[another_idea.id].should == ['0%', '0%', 1, 0]
      end
    end

    describe "blog articles section" do
      render_views

      before :each do
        @article = Factory(:article, article_type: 'blog')
      end

      it "should show a temporary text on home page when no there are no blog articles" do
        @article.update_attributes(article_type: 'statement')

        get :home

        response.body.should =~ /Ei kirjoituksia tällä hetkellä/
      end

      it "should show articles with type = 'blog'" do
        not_blog = Factory(:article, article_type: 'footer')

        get :home

        assigns(:blog_articles).should include(@article)
        assigns(:blog_articles).should_not include(not_blog)
      end

      it "should show only published blog articles" do
        unpublished = Factory(:article, publish_state: 'unpublished')
        moderated = Factory(:article, publish_state: 'in_moderation')

        get :home

        assigns(:blog_articles).should_not include(unpublished)
        assigns(:blog_articles).should_not include(moderated)
      end
    end
  end
end
