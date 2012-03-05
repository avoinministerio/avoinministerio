require 'spec_helper'

describe Comment do
  it { should belong_to :author }
  it { should belong_to :commentable }
  
  let(:comment) { Factory(:comment) }
  
  describe "Validations" do
    describe "body" do
      it "should be present" do
        comment.body = nil
        comment.should_not be_valid
      end
      
      it "should be reasonably long" do
        comment.body = "."
        comment.should_not be_valid
        comment.body = "OK"
        comment.should be_valid
      end
    end
    
    describe "associations" do
      it "is associated to an idea" do
        comment.commentable.should_not be_nil
        comment.commentable.should be_kind_of Idea
        comment.commentable = nil
        comment.should_not be_valid
      end
      
      it "is associated to an author" do
        comment.author.should_not be_nil
        comment.author.should be_kind_of Citizen
        comment.author = nil
        comment.should_not be_valid
      end
    end
  end
end
