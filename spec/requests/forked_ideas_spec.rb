require 'spec_helper'

describe "ForkedIdeas" do
  describe "GET /forked_ideas" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get forked_ideas_path
      response.status.should be(200)
    end
  end
end
