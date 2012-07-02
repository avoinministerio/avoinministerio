describe SignaturesControllerHelpers do
  describe "#guess_names" do
    it "guess lastname from beginning TUPAS name 'lastname firstname'" do
      helper.guess_names("Knuth Donald", "", "Knuth").should == ["Donald", "Knuth"]
    end
    it "guess lastname from end of TUPAS name 'lastname firstname'" do
      helper.guess_names("Donald Knuth", "", "Knuth").should == ["Donald", "Knuth"]
    end
    it "guess lastname from beginning TUPAS name 'lastname firstname firstname'" do
      helper.guess_names("Knuth Donald Ervin", "", "Knuth").should == ["Donald Ervin", "Knuth"]
    end
    it "guess lastname from end of TUPAS name 'lastname firstname firstname'" do
      helper.guess_names("Donald Ervin Knuth", "", "Knuth").should == ["Donald Ervin", "Knuth"]
    end
    it "guess returns same if lastname doesn't match TUPAS name" do
      helper.guess_names("Donald Ervin Knuth", "Donald", "Knuthi").should == ["Donald", "Knuthi"]
      helper.guess_names("Knuth Donald Ervin", "Donald", "Knuthi").should == ["Donald", "Knuthi"]
    end
  end
end
