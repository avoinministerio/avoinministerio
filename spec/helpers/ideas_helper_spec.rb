# encoding: UTF-8

require 'spec_helper'

describe IdeasHelper do
  let(:idea) { Factory(:idea) }
  
  describe "#idea_state_image" do
    let(:draft)     { Factory(:idea, state: "draft") }
    let(:proposal)  { Factory(:idea, state: "proposal") }
    let(:law)       { Factory(:idea, state: "law") }

    it "returns image tag for given idea and its state" do
      helper.idea_state_image(idea).should      =~ /state_1_idea.png/
      helper.idea_state_image(draft).should     =~ /state_2_draft.png/
      helper.idea_state_image(proposal).should  =~ /state_3_proposal.png/
      helper.idea_state_image(law).should       =~ /state_4_law.png/
    end
  end
  
  describe "#vote_in_words" do
    let(:citizen_0) { Factory(:citizen) }
    let(:citizen_1) { Factory(:citizen) }
    
    before do
      idea.vote(citizen_0, 0)
      idea.vote(citizen_1, 1)
    end
    
    it "returns lingual representation of the vote" do
      helper.vote_in_words(idea, citizen_0).should == "Ei"
      helper.vote_in_words(idea, citizen_1).should == "Kyllä"
    end
  end
end
