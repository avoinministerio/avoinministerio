require File.join(File.dirname(__FILE__), '..', '..', 'spec_helper')

describe Citizens::OmniauthCallbacksController do
  describe 'facebook' do
    it "should authenticate successfully" do
      @citizen = Factory.create :facebookin_erkki

      request.env['omniauth.auth'] = auth_hash
      request.env["devise.mapping"] = Devise.mappings[:citizen]

      get :facebook
      response.should redirect_to(root_path)
    end
  end
end
