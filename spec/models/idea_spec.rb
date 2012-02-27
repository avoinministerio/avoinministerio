require 'spec_helper'

describe Idea do
  it { should belong_to :author }

  let(:idea)    { Factory(:idea) }
  let(:citizen) { Factory(:citizen) }
    
  describe "#vote(citizen, option)" do
    it "casts a vote on an idea" do
      idea.vote(citizen, 1)
      idea.votes.count.should == 1
    end
    
    it "casts only one vote per idea per citizen" do
      idea.vote(citizen, 1)
      idea.votes.by(citizen).count.should == 1
      idea.vote(citizen, 1)
      idea.votes.by(citizen).count.should == 1
      idea.vote(citizen, 0)
      idea.votes.by(citizen).count.should == 1
    end
  end
  
  describe "#voted_by?(citizen)" do
    it "tells whether citizen has voted for the idea or not" do
      idea.voted_by?(citizen).should be_false
      idea.vote(citizen, 1)
      idea.voted_by?(citizen).should be_true
    end
  end
end
