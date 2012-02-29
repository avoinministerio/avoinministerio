require 'spec_helper'

describe Citizen do
  describe "with profile picture" do
    before do
      profile = Factory(:profile, :image => "http://www.facebook.com/images/1234.png")
      @citizen = Factory(:citizen, :profile => profile)
    end

    it "should use user specified profile picture" do
      @citizen.image.should == "http://www.facebook.com/images/1234.png"
    end
  end

  describe "without profile picture" do
    before do
      @citizen = Factory(:citizen, :email => "foo@example.com")
    end

    it "should use gravatar by default" do
      @citizen.image.should == "http://www.gravatar.com/avatar/b48def645758b95537d4424c84d1a9ff"
    end
  end

  it { should have_one :profile }
end
