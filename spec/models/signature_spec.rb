require 'spec_helper'

describe Signature do
  describe "Attributes" do
    it { should be_accessible(:state) }
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
end
