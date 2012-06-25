require 'spec_helper'

describe ProfilesController do
  let (:citizen) {
    Factory :citizen
  }

  get :edit do
    context "logged in" do
      before do
        sign_in citizen
        @vote = Factory :vote, :citizen => citizen
        @comment = Factory :comment, :author => citizen
      end
      action! do
        it "assigns the profile as @profile" do
          assigns(:profile).should == citizen.profile
        end
        it "assigns the citizen as @citizen" do
          assigns(:citizen).should == citizen
        end
        it "adds a voted idea into @voted_ideas" do
          assigns(:voted_ideas).should include @vote.idea
        end
        it "adds a commented idea into @commented_ideas" do
          assigns(:commented_ideas).should include @comment.commentable
        end
      end
    end
    context "as anonymous user" do
      before do
        @request.env['HTTP_REFERER'] = root_path
      end
      action! do
        its(:response) {should be_redirect}
        its(:response) {should redirect_to(root_path)}
      end
    end
  end

end
