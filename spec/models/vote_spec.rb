require 'spec_helper'

describe Vote do
  let(:idea)    { FactoryGirl.create(:idea) }
  let(:citizen) { FactoryGirl.create(:citizen) }
  
  describe ".by" do
    before do
      5.times { Vote.create(option: 1, idea: idea) }
      FactoryGirl.create(:vote, option: 1, citizen: citizen, idea: idea)
      FactoryGirl.create(:vote, option: 0, citizen: citizen, idea: nil)
    end

    subject { @scope.by(citizen) }
    
    it "returns votes by citizen" do
      @scope = Vote
      subject.size.should == 2
    end

    it "returns votes for a specific idea by citizen" do
      @scope = idea.votes
      subject.count.should == 1
      subject.first.citizen == citizen
    end
  end
  
  describe ".in_favor" do
    before do
      5.times { FactoryGirl.create(:vote, option: 1, idea: idea) }
      3.times { FactoryGirl.create(:vote, option: 0, idea: idea) }
    end
    
    subject { Vote.in_favor }
    
    it "returns votes in favor" do
      subject.count.should == 5
    end
  end
  
  describe ".against" do
    before do
      5.times { FactoryGirl.create(:vote, option: 1, idea: idea) }
      3.times { FactoryGirl.create(:vote, option: 0, idea: idea) }
    end
    
    subject { Vote.against }
    
    it "returns votes against" do
      subject.count.should == 3
    end
  end
end
