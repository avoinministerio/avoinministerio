require 'spec_helper'

describe PagesController do
  describe "#home" do
    it "should be successful" do
      get :home
      response.should be_success
    end

    describe "recent drafts section" do
      before :each do
        @recent_draft = Factory(:idea, state: 'draft')
        @recent_idea = Factory(:idea, state: 'idea')
      end

      it "should include only drafts to drafts section" do
        get :home
        assigns[:recent_drafts].should include(@recent_draft)
        assigns[:recent_drafts].should_not include(@recent_idea)
      end

      it "should calculate vote counts for a draft" do
        # 7 votes for and 4 votes against the idea
        7.times { Factory(:vote, idea: @recent_draft, option: 1) }
        4.times { Factory(:vote, idea: @recent_draft, option: 0) }

        # let's also create a draft without votes yet
        voteless_draft = Factory(:idea, state: 'draft')

        get :home

        assigns[:draft_counts].keys.should include(@recent_draft.id)
        assigns[:draft_counts][@recent_draft.id].should == [7.0/11, '64%', 4.0/11, '36%']

        assigns[:draft_counts].keys.should include(voteless_draft.id)
        assigns[:draft_counts][voteless_draft.id].should == [0.0, ' 0%', 0.0, ' 0%']
      end
    end
  end
end
