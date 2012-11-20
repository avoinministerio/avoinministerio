require "spec_helper"

describe ExpertSuggestionsController do
  describe "routing" do
    it "routes to #new" do
      { get: '/ideat/123-paras-idea/asiantuntijaehdotukset/uusi' }.should route_to(
          controller: 'expert_suggestions',
          action: 'new',
          locale: 'fi',
          idea_id: '123-paras-idea'
        )
    end

    it "routes to #create" do
      { post: '/ideat/123-paras-idea/asiantuntijaehdotukset' }.should route_to(
          controller: 'expert_suggestions',
          action: 'create',
          locale: 'fi',
          idea_id: '123-paras-idea'
        )
    end
  end
end
