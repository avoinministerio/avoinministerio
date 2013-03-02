# encoding: UTF-8

require 'spec_helper'

describe IdeasController do
  include Devise::TestHelpers # remove when helpers are globally included
  include ActionView::Helpers::UrlHelper
  render_views
  
  let (:citizen) {
    FactoryGirl.create :citizen
  }

  describe "#index" do
    it "should be successful" do
      get :index
      response.should be_success
    end

    it "should include ideas on page" do
      @recent_ideas = []
      20.times { @recent_ideas << FactoryGirl.create(:idea, state: 'idea') }
      get :index
      @recent_ideas.each do |idea|
        assigns(:ideas).should include(idea)
      end
    end
  end

  describe "#create" do
    before :each do
      @valid_attr = { :title   => "Idea uudesta laista",
                      :body    => "Hankitaan kaikille kansalaisille ...",
                      :summary => "Hyvä idea" }
      @invalid_attr = { :title   => "Just",
                        :body    => "Bad",
                        :summary => "Info" }
    end

    it "should create an idea if user signed_in and attributes are valid" do
      sign_in citizen
      lambda do
        post :create, :idea => @valid_attr
        flash[:notice].should_not be_nil
      end.should change(Idea, :count).by(1)
    end

    it "should not create an idea if user signed_in and attributes are invalid" do
      sign_in citizen
      lambda do
        post :create, :idea => @invalid_attr
        flash[:notice].should be_nil
      end.should_not change(Idea, :count).by(1)
    end
    
    it "should not create an idea if user is a guest" do
      lambda do
        post :create, :idea => @valid_attr
        flash[:notice].should be_nil
      end.should_not change(Idea, :count).by(1)
    end
  end

  describe "#update" do
    before :each do
      @idea = FactoryGirl.create(:idea, state: 'idea')
    end

    it "should change idea's attributes" do
      sign_in citizen
      put :update, id: @idea, idea: FactoryGirl.attributes_for(:idea, title: "New idea's title")
      @idea.reload
      @idea.title.should eq("New idea's title")
    end
  end

  describe "#edit" do
    before :each do
      @idea = FactoryGirl.create(:idea, state: 'idea')
    end

    it "should be successful" do
      sign_in citizen 
      get :edit, id: @idea
      response.should be_success
    end
  end

  describe "#show" do
    before :each do
      @idea = FactoryGirl.create :idea
    end

    it "should show an idea" do
      get :show, id: @idea.id
      response.body.should include(@idea.title)
      response.body.should include(@idea.author.name)
    end

    it "should show an idea with slugged url" do
      get :show, id: "#{@idea.id}-#{@idea.slug}"
      response.body.should include(@idea.title)
      response.body.should include(@idea.author.name)
    end

    describe "logged in user" do
      before :each do
        sign_in citizen
      end

      it "should show edit link if current_citizen is the author of the idea" do
        @idea.author = citizen
        @idea.save!
        get :show, id: @idea.id
        response.body.should include(link_to(I18n.t("idea.links.edit_idea"), edit_idea_path(@idea)))
      end

      it "should show the voting form if not already voted" do
        get :show, id: @idea.id
        response.body.should include(@idea.title)
      end

      it "should show an option to change opinion if already voted" do
        @idea.vote(citizen, 1)
        get :show, id: @idea.id
        response.body.should include(@idea.title)
      end
    end
  end
end
