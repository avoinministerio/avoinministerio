require "spec_helper"

describe CitizenMailer do

  describe 'welcome_email' do
    it "should send deliver an email" do
      citizen = Factory.build(:citizen)
      CitizenMailer.welcome_email(citizen, [], []).deliver
      sent_email = ActionMailer::Base.deliveries.last

      sent_email.subject.should == "Welcome to AvoinMinisterio"
      sent_email.to.should == [citizen.email]
    end
  end
end