require 'spec_helper'

describe Citizen do
  describe "#image" do
    context "with profile picture" do
      before do
        profile = Factory(:profile, :image => "http://www.facebook.com/images/1234.png")
        @citizen = Factory(:citizen, :profile => profile)
      end

      it "should use user specified profile picture" do
        @citizen.image.should == "http://www.facebook.com/images/1234.png"
      end
    end

    context "without profile picture" do
      before do
        @citizen = Factory(:citizen, :email => "foo@example.com")
      end

      it "should use gravatar as a fallback" do
        @citizen.image.should == "https://secure.gravatar.com/avatar/b48def645758b95537d4424c84d1a9ff"
      end
    end
  end
  
  describe "#locked?" do
    let(:locked_citizen)    { Factory(:citizen, locked_at: Time.now.in_time_zone) }
    let(:unlocked_citizen)  { Factory(:citizen) }
    
    it "tells if a Citizen account is locked" do
      locked_citizen.locked?.should be_true
      unlocked_citizen.locked?.should be_false
    end
  end
  
  describe "#lock!" do
    let(:citizen)   { Factory(:citizen) }
    
    it "locks a citizen account" do
      citizen.locked?.should be_false
      citizen.lock!
      citizen.locked?.should be_true
    end
  end
  
  describe "#unlock!" do
    let(:citizen)   { Factory(:citizen, locked_at: Time.now.in_time_zone) }
    
    it "locks a citizen account" do
      citizen.locked?.should be_true
      citizen.unlock!
      citizen.locked?.should be_false
    end    
  end
  
  describe "#active_for_authentication?" do
    let(:locked_citizen)    { Factory(:citizen, locked_at: Time.now.in_time_zone) }
    let(:unlocked_citizen)  { Factory(:citizen) }
    
    it "tells if a Citizen account can log in" do
      locked_citizen.active_for_authentication?.should be_false
      unlocked_citizen.active_for_authentication?.should be_true
    end
  end

  it { should have_one :profile }
end
