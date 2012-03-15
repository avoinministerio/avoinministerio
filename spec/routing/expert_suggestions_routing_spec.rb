require "spec_helper"

describe ExpertSuggestionsController do
  describe "routing" do

    it "routes to #index" do
      get("/expert_suggestions").should route_to("expert_suggestions#index")
    end

    it "routes to #new" do
      get("/expert_suggestions/new").should route_to("expert_suggestions#new")
    end

    it "routes to #show" do
      get("/expert_suggestions/1").should route_to("expert_suggestions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/expert_suggestions/1/edit").should route_to("expert_suggestions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/expert_suggestions").should route_to("expert_suggestions#create")
    end

    it "routes to #update" do
      put("/expert_suggestions/1").should route_to("expert_suggestions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/expert_suggestions/1").should route_to("expert_suggestions#destroy", :id => "1")
    end

  end
end
