require 'spec_helper'

describe Citizen do

  describe "Attributes" do
    it { should be_accessible(:email) }
    it { should be_accessible(:password) }
    it { should be_accessible(:password_confirmation) }
    it { should be_accessible(:remember_me) }
    it { should be_accessible(:profile) }
    it { should be_accessible(:profile_attributes) }

    describe "Validations" do

    end

  end

  describe "Associations" do
    it { should have_one(:profile) }
    it { should have_one(:authentication) }
    it { should have_many(:ideas) }
    it { should have_many(:comments) }
    it { should have_many(:idea_comments) }

    describe "Validations" do

    end
  end

  describe "Class Methods" do
    describe "#to_csv" do
      before(:each) do
        @default_citizen = Factory(:citizen)
        Factory(:idea, :author => @default_citizen)
      end

      it "should use fixed fields for header row" do
        Citizen.header_field_names_for_csv.should == ["id", "email", "firstname", "lastname", "idea_count", "comment_count", "comments_on_ideas", "votes_on_ideas", "earliest_idea_date", "idea_date_last_1", "idea_date_last_2", "idea_date_last_3", "idea_date_last_4", "idea_date_last_5"]
      end

      it "should return csv formatted string"
    end
  end

  describe "Instance Methods" do
    let(:citizen) { Factory(:citizen) }

    describe "#number_of_comments_on_citizens_ideas" do
      it "should count how many comments there are in ideas which area owned by citizen" do
        2.times { |i| _idea = Factory(:idea, :author => citizen); Factory(:comment, commentable: _idea)}
        citizen.number_of_comments_on_citizens_ideas.should == 2
      end
    end

    describe "#number_of_comments" do
      it "should count all the comments which citized has created" do
        2.times { |i| _idea = Factory(:idea); Factory(:comment, commentable: _idea, author: citizen)}
        citizen.number_of_comments.should == 2
      end
    end

    describe "#number_of_ideas" do
      it "should count all the ideas which citized has created" do
        Factory(:idea, :author => citizen)
        citizen.number_of_ideas.should == 1
      end
    end

    describe "#number_of_votes_on_citizens_ideas" do
      it "should count how many votes there are in ideas which area owned by citizen" do
        2.times { |i| _idea = Factory(:idea, author: citizen); Factory(:vote, idea: _idea) }
        citizen.number_of_votes_on_citizens_ideas.should == 2
      end
    end

    describe "#fields_for_csv" do
      it "should list all attributes that are exported to csv"
    end

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
  end
end
