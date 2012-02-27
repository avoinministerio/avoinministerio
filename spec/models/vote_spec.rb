require 'spec_helper'

describe Vote do
  let(:idea)    { Factory(:idea) }
  let(:citizen) { Factory(:citizen) }
  
  describe ".by(citizen)" do
    before do
      5.times { Vote.create(option: 1, idea: idea) }
      Vote.create(option: 1, citizen: citizen, idea: idea)
      Vote.create(option: 0, citizen: citizen, idea: nil)
    end

    subject { @scope.by(citizen) }
    
    it "returns votes by citizen" do
      @scope = Vote
      subject.size.should == 2
    end

    it "returns votes for a specific idea by citizen" do
      @scope = idea.votes
      subject.size.should == 1
    end
  end
  
  describe ".in_favor" do
    before do
      5.times { Vote.create(option: 1, idea: idea) }
      3.times { Vote.create(option: 0, idea: idea) }
    end
    
    subject { Vote.in_favor }
    
    it "returns votes in favor" do
      subject.size.should == 5
    end
  end
  
  describe ".against" do
    before do
      5.times { Vote.create(option: 1, idea: idea) }
      3.times { Vote.create(option: 0, idea: idea) }
    end
    
    subject { Vote.against }
    
    it "returns votes against" do
      subject.size.should == 3
    end
  end
end
