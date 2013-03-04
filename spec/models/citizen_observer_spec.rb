require 'spec_helper'

describe CitizenObserver do
  describe "after_create" do
    it "should send a welcome email to most recently created user" do
      citizen = FactoryGirl.create(:citizen)
      sent_email = ActionMailer::Base.deliveries.last

      sent_email.subject.should == "Welcome to AvoinMinisterio"
      sent_email.to.should == [citizen.email]
    end
  end
end