require 'spec_helper'

describe CommentsController do

  describe "#hide" do
    before :each do
      @comment = Factory :comment
    end

    it "should hide the comment when it's author asks for it" do
      sign_in @comment.author

      expect {
        post :hide, idea_id: @comment.commentable.id, comment_id: @comment.id, format: :js
        @comment.reload
      }.should change(@comment, :publish_state).from('published').to('unpublished')

      response.should be_success
      response.should render_template('comments/hide')
    end

    it "shouldn't hide when a request made by other than author" do
      citizen = Factory :citizen
      sign_in citizen

      expect {
        post :hide, idea_id: @comment.commentable.id, comment_id: @comment.id, format: :js
        @comment.reload
      }.should_not change(@comment, :publish_state)
      response.should_not be_success
      response.status.should == 401
    end

    it "should't hide without logged in citizen" do
      expect {
        post :hide, idea_id: @comment.commentable.id, comment_id: @comment.id, format: :js
        @comment.reload
      }.should_not change(@comment, :publish_state)
      response.should_not be_success
      response.status.should == 401
    end
  end
end
