require 'spec_helper'

describe Admin::IdeasController do

  before :each do
    @administrator = Factory(:administrator)
    sign_in :administrator, @administrator
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
