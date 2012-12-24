# encoding: UTF-8

require 'spec_helper'

describe IdeasController do
  include Devise::TestHelpers # remove when helpers are globally included
  include ActionView::Helpers::UrlHelper
  render_views

  describe "#show" do
    before :each do
      @idea = Factory :idea
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
        @citizen = Factory.create :citizen
        sign_in @citizen
      end

      it "should show edit link if current_citizen is the author of the idea" do
        @idea.author = @citizen
        @idea.save!
        get :show, id: @idea.id
        response.body.should include(link_to(I18n.t("idea.links.edit_idea"), edit_idea_path(@idea)))
      end

      it "should show the voting form if not already voted" do
        get :show, id: @idea.id
        response.body.should include(@idea.title)
      end

      it "should show an option to change opinion if already voted" do
        @idea.vote(@citizen, 1)
        get :show, id: @idea.id
        response.body.should include(@idea.title)
      end
    end
  end
end
