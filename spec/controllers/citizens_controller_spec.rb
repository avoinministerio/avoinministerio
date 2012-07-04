require 'spec_helper'

describe CitizensController do
  let (:citizen) {
    Factory :citizen
  }

  get :edit do
    before do
      sign_in citizen
    end
    action! do
      it "assigns the citizen as @citizen" do
        assigns(:citizen).should == citizen
      end
    end
  end
  
  post :update do
    pending "Need a way to check if the password has changed"
  end

end
