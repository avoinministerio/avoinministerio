require 'spec_helper'

describe "ExpertSuggestions" do
  describe "GET /expert_suggestions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get expert_suggestions_path
      response.status.should be(200)
    end
  end
end
