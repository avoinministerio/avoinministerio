require 'spec_helper'

describe Profile do
  it { should belong_to :citizen }
  
  describe "#name" do
    let(:citizen) { Factory(:citizen) }
    
    it "returns the full name of the citizen" do
      citizen.name.should == "Erkki Esimerkki"
    end
  end
end
