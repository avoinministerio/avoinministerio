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
  
  describe "#vote_counts" do
    before do
      5.times { Vote.create(option: 1, idea: idea) }
      3.times { Vote.create(option: 0, idea: idea) }
    end
    
    it "returns the vote counts" do
      counts = idea.vote_counts
      counts.should be_kind_of Hash
      counts.size.should == 2
      counts[0].should == 3
      counts[1].should == 5
    end
  end
  
  describe "Publishing state of an idea" do
    it "is published by default" do
      idea.published?.should be_true
    end
    
    it "can be unpublished" do
      idea.unpublish!
      idea.unpublished?.should be_true
      idea.published?.should be_false
    end
    
    it "can be sent for moderation" do
      idea.moderate!
      idea.published?.should be_false
      idea.in_moderation?.should be_true
    end
  end
end
