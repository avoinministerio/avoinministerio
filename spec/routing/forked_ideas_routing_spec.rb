require "spec_helper"

describe ForkedIdeasController do
  describe "routing" do

    it "routes to #index" do
      get("/forked_ideas").should route_to("forked_ideas#index")
    end

    it "routes to #new" do
      get("/forked_ideas/new").should route_to("forked_ideas#new")
    end

    it "routes to #show" do
      get("/forked_ideas/1").should route_to("forked_ideas#show", :id => "1")
    end

    it "routes to #edit" do
      get("/forked_ideas/1/edit").should route_to("forked_ideas#edit", :id => "1")
    end

    it "routes to #create" do
      post("/forked_ideas").should route_to("forked_ideas#create")
    end

    it "routes to #update" do
      put("/forked_ideas/1").should route_to("forked_ideas#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/forked_ideas/1").should route_to("forked_ideas#destroy", :id => "1")
    end

  end
end
