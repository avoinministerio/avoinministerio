require 'spec_helper'

describe Tag do
  describe "tokens" do
    it "should return tags" do
      @tags = []
      @tags << Tag.create(:name => "tag1")
      Tag.tokens("tag1").should == @tags
    end

    it "should return tags even if tag do not exist" do
      Tag.tokens("new tag").should == [ { :id => "<<<new tag>>>", :name => "new tag"} ]
    end
  end

  describe "ids_from_tokens" do
    before(:each) do
      Tag.create(:name => "tag1")
      Tag.create(:name => "tag2")
      Tag.create(:name => "tag3")
    end

    it "should return array of ids (only for new tokens)" do
      Tag.ids_from_tokens("tag1,tag2,tag3,<<<tag4>>>").should == ["tag1", "tag2", "tag3", "4"] #where 4 is id of tag4
    end
  end

  describe "get_ids_by_name" do
    before(:each) do
      Tag.create(:name => "tag1")
      Tag.create(:name => "tag2")
      Tag.create(:name => "tag3")
    end

    it "should return array of ids" do
      Tag.get_ids_by_name("tag1,tag2,tag3").should == [1, 2, 3]
    end
  end

  describe "score" do
    before(:each) do
      @tag = Tag.create(:name => "tag1")
    end

    it "should return score of tag" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
      @tag.score(1).should == 5
    end

    it "should return custom score of tag" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1, :status => "suggested", :score => 1)
      @tag.score(1).should == 1
    end
  end

  describe "status" do
    before(:each) do
      @tag = Tag.create(:name => "tag1")
    end

    it "should return 'approved' status" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
      @tag.status(1).should == "approved"
    end

    it "should return 'suggested' status" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1, :status => "suggested", :score => 1)
      @tag.status(1).should == "suggested"
    end
  end

  describe "approved?" do
    before(:each) do
      @tag = Tag.create(:name => "tag1")
    end

    it "should return true for approved tag" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
      @tag.approved?(1).should == true
    end

    it "should return false for suggested tag" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1, :status => "suggested", :score => 1)
      @tag.approved?(1).should == false
    end
  end

  describe "suggested?" do
    before(:each) do
      @tag = Tag.create(:name => "tag1")
    end

    it "should return false for approved tag" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
      @tag.suggested?(1).should == false
    end

    it "should return true for suggested tag" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1, :status => "suggested", :score => 1)
      @tag.suggested?(1).should == true
    end
  end

  describe "vote_limit?" do
    before(:each) do
      @tag = Tag.create(:name => "tag1")
    end

    it "should return false for tag with score >= 20" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1, :score => 20, :status => "approved")
      @tag.vote_limit?(1).should == true
    end

    it "should return true for tag <= 20" do
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1, :score => 19, :status => "approved")
      @tag.vote_limit?(1).should == false
    end
  end
  
  describe "citizen voted?" do
    before(:each) do
      @voted_tag = Tag.create(:name => "tag1")
      @unvoted_tag = Tag.create(:name => "tag2")
      @voted = TagVote.create(:idea_id => 1, :tag_id => 1, :citizen_id => 1)
    end

    it "should return true for voted tag" do
      @voted_tag.citizen_voted?(1, 1).should == true
    end

     it "should return true for unvoted tag" do
      @unvoted_tag.citizen_voted?(1, 1).should == false
    end
  end

  describe "vote_for" do
    before(:each) do
      @tag = Tag.create(:name => "tag1")
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
    end

    it "should increase score of tagging" do
      Tag.vote_for(1, 1, 1)
      Tagging.all.last.score.should == 6
    end 

    it "should create tag vote" do
      TagVote.all.should == []
      Tag.vote_for(1, 1, 1)
      TagVote.all.should_not == []
    end
  end

  describe "voted_for?" do
    before(:each) do
      @tag_for = Tag.create(:name => "tag1")
      @tagging_for = Tagging.create(:tag_id => 1, :idea_id => 1)
      Tag.vote_for(1, 1, 1)
      @tag_against = Tag.create(:name => "tag2")
      @tagging_against = Tagging.create(:tag_id => 2, :idea_id => 1)
      Tag.vote_against(1, 2, 1)
    end

    it "should return true if voted for" do
      @tag_for.voted_for?(1, 1).should == true
    end 

    it "should return false if voted against" do
      @tag_against.voted_for?(1, 1).should == false
    end
  end

  describe "vote_against" do
    before(:each) do
      @tag = Tag.create(:name => "tag1")
      @tagging = Tagging.create(:tag_id => 1, :idea_id => 1)
    end

    it "should decrease score of tagging" do
      Tag.vote_against(1, 1, 1)
      Tagging.all.last.score.should == 4
    end 

    it "should create tag vote" do
      TagVote.all.should == []
      Tag.vote_for(1, 1, 1)
      TagVote.all.should_not == []
    end
  end
end
