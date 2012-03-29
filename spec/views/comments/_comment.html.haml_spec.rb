require 'spec_helper'

describe "comments/_comment.html.haml" do
  include Devise::TestHelpers # remove when helpers are globally included
  # include ActionView::Helpers::UrlHelper

  before :each do
    @comment = assign(:comment, Factory(:comment))
  end

  it "should show a hide comment link for author" do
    author = @comment.author
    sign_in author

    render @comment
    rendered.should match(link_to('Piilota kommentti', idea_comment_hide_path(@comment.commentable, @comment), remote: true, method: :post, confirm: 'Vahvista kommentin piilotus'))
  end

  it "should not show a hide comment link for other users" do
    citizen = Factory :citizen
    sign_in citizen

    render @comment
    rendered.should_not match /Piilota kommentti/
  end

  it "should not show a hide comment link when visitor not logged in" do
    render @comment
    rendered.should_not match /Piilota kommentti/
  end
end
