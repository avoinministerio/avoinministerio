require 'spec_helper'

describe SignaturesController do
  let (:citizen) { FactoryGirl.create :citizen }
  let (:idea) { FactoryGirl.create :idea }

  before do
    sign_in citizen
  end

  describe "GET introduction" do
    it "renders introduction view" do
      get :introduction, :id => idea.id
      response.should render_template("introduction")
    end
  end

  describe "POST sign" do
    before do
      @vote = FactoryGirl.create :vote, :citizen => citizen
      @comment = FactoryGirl.create :comment, :author => citizen
    end

    it "assigns the newly created Signature as @signature" do
      post :sign,
           :id => idea.id,
           :accept_general => 1,
           :accept_non_eu_server => 1,
           :publicity => "Normal"
      assigns(:signature).should_not be nil
    end

    it "assigns available authentication services (tupas services) as @tupas_services" do
      post :sign,
           :id => idea.id,
           :accept_general => 1,
           :accept_non_eu_server => 1,
           :publicity => "Normal"
      assigns(:tupas_services).length.should be 7
    end
  end
end
