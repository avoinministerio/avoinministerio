require 'spec_helper'

describe Signature do
  describe "Attributes" do
    # if we remove state from attr_accessible then it's impossible to create new signatures 
    # without mass_assignment non accessible field error
    # it { should_not be_accessible(:state) }
    it { should be_accessible(:firstnames) }
    it { should be_accessible(:lastname) }
    it { should be_accessible(:birth_date) }
    it { should be_accessible(:occupancy_county) }
    it { should be_accessible(:vow) }
    it { should be_accessible(:signing_date) }
    it { should be_accessible(:stamp) }
    it { should be_accessible(:started) }

    describe "Validations" do
    end
  end

  describe "Associations" do
    it { should belong_to(:citizen) }
    it { should belong_to(:idea) }

    describe "Validations" do
      it { should validate_presence_of(:citizen_id) }
      it { should validate_presence_of(:idea_id) }
    end
  end

  describe "create_with_citizen_and_idea" do
    before do
      @citizen = mock_model(Citizen, :first_names => "John", :last_name => "Doe")
      @idea = FactoryGirl.create :idea, :title => "helmet compulsory"

      @signature = Signature.create_with_citizen_and_idea(@citizen, @idea)
    end

    it "builds a new Signature" do
      @signature.new_record?.should be_true
    end

    it "assigns Citizen names" do
      @signature.firstnames.should == "John"
      @signature.lastname.should == "Doe"
    end

    it "assigns details from the Idea" do
      @signature.idea_title.should == "helmet compulsory"
      @signature.idea_date.should == @idea.updated_at
    end

    it { @signature.state.should == "initial" }
    it { @signature.vow.should be_false }
    it { @signature.occupancy_county.should == "" }
    it { @signature.started.should be_an_instance_of(ActiveSupport::TimeWithZone)}
    
    it "assigns a randomized DateTime string as stamp" do
      @signature.stamp.should match(/\A[0-9]{14,20}\Z/)
    end
  end

  it "should prevent duplicate authenticated signatures" do
    @citizen2 = FactoryGirl.create :citizen
    @idea2 = FactoryGirl.create :idea
    @signature2 = Signature.new( "citizen_id"=> @citizen2.id,
                                 "idea_id"=>@idea2.id,
                                 "idea_title"=> @idea2.title,
                                 "idea_date"=>@idea2.created_at,
                                 "birth_date"=>Time.now,
                                 "occupancy_county"=>"",
                                 "vow"=>nil,
                                 "signing_date"=>nil,
                                 "state"=>"authenticated",
                                 "stamp"=>"20130402181304639309",
                                 "started"=>Time.now,
                                 "firstnames"=>@citizen2.first_name,
                                 "lastname"=>@citizen2.last_name,
                                 "accept_general"=>true,
                                 "accept_non_eu_server"=>true,
                                 "accept_publicity"=>"Normal",
                                 "accept_science"=>nil,
                                 "idea_mac"=>nil,
                                 "service"=>nil)
    @signature2.save
    @signature3 = Signature.new( "citizen_id"=> @citizen2.id,
                                 "idea_id"=>@idea2.id,
                                 "idea_title"=> @idea2.title,
                                 "idea_date"=>@idea2.created_at,
                                 "birth_date"=>Time.now,
                                 "occupancy_county"=>"",
                                 "vow"=>nil,
                                 "signing_date"=>nil,
                                 "state"=>"authenticated",
                                 "stamp"=>"20130402181304639309",
                                 "started"=>Time.now,
                                 "firstnames"=>@citizen2.first_name,
                                 "lastname"=>@citizen2.last_name,
                                 "accept_general"=>true,
                                 "accept_non_eu_server"=>true,
                                 "accept_publicity"=>"Normal",
                                 "accept_science"=>nil,
                                 "idea_mac"=>nil,
                                 "service"=>nil)
                                
    @signature3.save
    @signature3.save.should be_false
  end

end
