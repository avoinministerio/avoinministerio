# encoding: UTF-8

require 'spec_helper'

describe Idea do
  it { should belong_to :author }
  it { should ensure_length_of(:title).is_at_least(5).with_short_message(/on liian lyhyt/) }
  it { should ensure_length_of(:body).is_at_least(5).with_short_message(/ideasi hieman/) }

  let(:idea)    { Factory(:idea) }
  let(:citizen) { Factory(:citizen) }

  describe ".per_page" do
    it "returns number of items per page" do
      Idea.per_page.should be_a Fixnum
      Idea.per_page.should > 0
    end
  end

  describe "Validations" do
    describe "associations" do
      it "is associated to an author" do
        idea.author.should_not be_nil
        idea.author.should be_kind_of Citizen
        idea.author = nil
        idea.should_not be_valid
      end
    end
  end

  describe "#vote" do
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

  describe "#voted_by?" do
    it "tells whether citizen has voted for the idea or not" do
      idea.voted_by?(citizen).should be_false
      idea.vote(citizen, 1)
      idea.voted_by?(citizen).should be_true
    end
  end

  describe "#vote_counts" do
    before do
      5.times { Factory(:vote, option: 1, idea: idea) }
      3.times { Factory(:vote, option: 0, idea: idea) }
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

  describe "Scopes" do
    before do
      3.times { Factory(:idea, publish_state: "published" ) }
      2.times { Factory(:idea, publish_state: "unpublished" ) }
      1.times { Factory(:idea, publish_state: "in_moderation" ) }
    end

    describe ".published" do
      it "returns published ideas" do
        ideas = Idea.published
        ideas.count.should == 3
        ideas.map(&:published?).should be_true
      end
    end

    describe ".unpublished" do
      it "returns unpublished ideas" do
        ideas = Idea.unpublished
        ideas.count.should == 2
        ideas.map(&:unpublished?).should be_true
      end
    end

    describe ".in_moderation" do
      it "returns ideas that are in moderation" do
        ideas = Idea.in_moderation
        ideas.count.should == 1
        ideas.map(&:in_moderation?).should be_true
      end
    end
  end
end
