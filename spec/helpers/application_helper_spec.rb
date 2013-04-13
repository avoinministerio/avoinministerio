require 'spec_helper'

describe ApplicationHelper do

  describe "#markdown" do

    before(:each) do
      @input = "sample simple text "
    end

    it "should pass valid normal text" do
      helper.markdown(@input).should == "<p>sample simple text </p>\n"
    end

    it "should create normal links" do
      @input += "http://www.google.fi/"
      helper.markdown(@input).should == "<p>sample simple text <a href=\"http://www.google.fi/\">http://www.google.fi/</a></p>\n"
    end

    it "should create embeded youtube videos" do
      @input += "http://www.youtube.com/watch?v=ClIEEvn5MKk"
      helper.markdown(@input).should == "<p>sample simple text <iframe allowfullscreen=\"\" height=\"192\" src=\"https://www.youtube.com/embed/ClIEEvn5MKk\" style=\"border: none;\" width=\"310\">   </iframe></p>\n"
    end

  end

end
