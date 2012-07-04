require 'spec_helper'

describe ProfilesController do
  let (:citizen) {
    Factory :citizen
  }

  get :edit do
    before do
      sign_in citizen
    end
    action! do
      it "assigns the profile as @profile" do
        assigns(:profile).should == citizen.profile
      end
    end
  end
  
  get :show do
    before do
      sign_in citizen
      @vote = Factory :vote, :citizen => citizen
      @comment = Factory :comment, :author => citizen
    end
    action! do
      it "adds a voted idea into @voted_ideas" do
        assigns(:voted_ideas).should include @vote.idea
      end
      it "adds a commented idea into @commented_ideas" do
        assigns(:commented_ideas).should include @comment.commentable
      end
    end
  end
  
  post :update do
    context "with a valid profile" do
      params {{:profile => {
            :receive_newsletter => true,
            :receive_other_announcements => true,
            :receive_weekletter => true,
            :first_names => "Erkki Kalevi",
            :first_name => "Erkki",
            :last_name => "Esimerkki",
            :image => "http://www.example.com/avatar.png",
            :accept_science => true,
            :accept_terms_of_use => true
          }}}
      it "logged in" do
        sign_in citizen
        action! do
          citizen.profile.reload
          citizen.profile.receive_newsletter.should be_true
          citizen.profile.receive_other_announcements.should be_true
          citizen.profile.receive_weekletter.should be_true
          citizen.profile.first_names.should == "Erkki Kalevi"
          citizen.profile.first_name.should == "Erkki"
          citizen.profile.last_name.should == "Esimerkki"
          citizen.profile.image.should == "http://www.example.com/avatar.png"
          citizen.profile.accept_science.should be_true
          citizen.profile.accept_terms_of_use.should be_true
        end
      end
      it "as anonymous user" do
        original_profile = citizen.profile.dup
        action! do
          citizen.profile.reload
          citizen.profile.attributes.should == original_profile.attributes
        end
      end
    end
    context "without first name" do
      params {{:profile => {
            :receive_newsletter => true,
            :receive_other_announcements => true,
            :receive_weekletter => true,
            :first_names => "",
            :first_name => "",
            :last_name => "Esimerkki",
            :image => "http://www.example.com/avatar.png",
            :accept_science => true,
            :accept_terms_of_use => true
          }}}
      before do
        @original_profile = citizen.profile.dup
      end
      it "logged in" do
        sign_in citizen
        action! do
          citizen.profile.reload
          citizen.profile.attributes.should == @original_profile.attributes
          response.should render_template(:edit)
        end
      end
      it "as anonymous user" do
        action! do
          citizen.profile.reload
          citizen.profile.attributes.should == @original_profile.attributes
        end
      end
    end
  end

end
