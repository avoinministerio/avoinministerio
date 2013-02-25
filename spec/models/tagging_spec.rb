require 'spec_helper'

describe Tagging do
  describe "basic_scores" do
    before(:each) do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
    end

    it "should set 'approved' status for tagging" do
      @tagging.status == "approved"
    end

    it "should set correct scores for tagging" do
      @tagging.score == 5
    end
  end

  describe "check_status" do
    before(:each) do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
    end

    it "should return 'approved' status for tags with score above or equal 5" do
      @tagging.check_status.should == "approved"
      @tagging.increase_score
      @tagging.check_status.should == "approved"
    end

    it "should return 'suggested' status for tags with score below 5" do
      @tagging.decrease_score
      @tagging.check_status.should == "suggested"
    end
  end

  describe "increase_score" do
    before(:each) do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
    end

    it "should increase score of tagging by 1" do
      @tagging.score == 5
      @tagging.increase_score
      @tagging.score == 6
    end
  end

  describe "decrease_score" do
    before(:each) do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
    end

    it "should increase score of tagging by 1" do
      @tagging.score == 5
      @tagging.decrease_score
      @tagging.score == 4
    end

    it "should destroy tagging with score below -5" do
      @tagging.score == 5
      10.times do |x|
        @tagging.decrease_score
      end
      @tagging.should_not == -5
    end
  end
end
