require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Citizens::OmniauthCallbacksController do
  describe 'facebook' do
    it "should authenticate successfully" do
      @citizen = Factory.create :facebookin_erkki

      request.env['omniauth.auth'] = auth_hash
      request.env["devise.mapping"] = Devise.mappings[:citizen]

      get :facebook
      controller.current_citizen.should == @citizen
      response.should redirect_to(root_path)
    end

    it "should authenticate successfully and redirect to original page" do
      @citizen = Factory.create :facebookin_erkki

      request.env['omniauth.auth'] = auth_hash
      request.env["devise.mapping"] = Devise.mappings[:citizen]
      request.env['omniauth.origin'] = new_idea_path

      get :facebook
      response.should redirect_to(new_idea_path)
    end

    it "should create a new citizen and a new authentication if not existing" do
      request.env['omniauth.auth'] = auth_hash
      request.env["devise.mapping"] = Devise.mappings[:citizen]

      lambda {
        lambda {
          get :facebook
        }.should change(Citizen, :count).by(1)
      }.should change(Authentication, :count).by(1)
      controller.citizen_signed_in?.should be_true
      response.should redirect_to(root_path)
    end
  end
end
