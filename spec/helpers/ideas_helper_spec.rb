# encoding: UTF-8

require 'spec_helper'

describe IdeasHelper do
  let(:idea) { Factory(:idea) }
  
  describe "#idea_state_image" do
    let(:draft)     { Factory(:idea, state: "draft") }
    let(:proposal)  { Factory(:idea, state: "proposal") }
    let(:law)       { Factory(:idea, state: "law") }

    it "returns image tag for given idea and its state" do
      helper.idea_state_image(idea).should      =~ /state_1_idea.png/
      helper.idea_state_image(draft).should     =~ /state_2_draft.png/
      helper.idea_state_image(proposal).should  =~ /state_3_proposal.png/
      helper.idea_state_image(law).should       =~ /state_4_law.png/
    end
  end
  
  describe "#vote_in_words" do
    let(:citizen_0) { Factory(:citizen) }
    let(:citizen_1) { Factory(:citizen) }
    
    before do
      idea.vote(citizen_0, 0)
      idea.vote(citizen_1, 1)
    end
    
    it "returns lingual representation of the vote" do
      helper.vote_in_words(idea, citizen_0).should == "Ei"
      helper.vote_in_words(idea, citizen_1).should == "Kyllä"
    end
  end
  
  describe "#shorten_and_highlight" do
    it "shortens and highlights given text" do
      shortened_and_highlighted = helper.shorten_and_highlight(
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do 
eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "lorem ipsum",
        50,
        "«",
        "»")
      shortened_and_highlighted.length.should == 50 + " »".length
      shortened_and_highlighted.should include(
        '<span class="match">Lorem ipsum</span>')
    end
    
    it "escapes HTML syntax" do
      escaped = helper.shorten_and_highlight(
        '<script type="text/javascript">alert("XSS")</script>',
        "XSS",
        100,
        "«",
        "»")
      escaped.should_not include '<script type="text/javascript">'
      escaped.should include '&lt;script type=&quot;text/javascript&quot;&gt;'
    end
    
    it "does not highlight anything if the pattern doesn't match the text" do
      shortened = helper.shorten_and_highlight(
        "Lorem ipsum dolor sit amet", "äoughÄ", 100, "«", "»")
      shortened.should_not include '<span class="match">'
    end
    
    it "truncates the string at the beginning if the first match is too far" do
      shortened_and_highlighted = helper.shorten_and_highlight(
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do 
eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "dolore magna aliqua",
        50,
        "«",
        "»")
      shortened_and_highlighted.should_not include "Lorem ipsum"
      shortened_and_highlighted.should include(
        '<span class="match">dolore magna aliqua</span>')
      shortened_and_highlighted.should =~ /^« /
    end
    
    it "does not highlight anything if the first match doesn't fit in the truncated string" do
      shortened = helper.shorten_and_highlight(
        "Lorem ipsum dolor sit amet", "lorem ipsum", 10, "«", "»")
      shortened.should_not include '<span'
    end
    
    it "inserts the ending sign" do
      shortened_and_highlighted = helper.shorten_and_highlight(
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do 
eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "lorem ipsum",
        50,
        "«",
        "»")
      shortened_and_highlighted.should =~ / »$/
    end
    
    it "does not insert the starting sign if the string hasn't been truncated at the beginning" do
      shortened_and_highlighted = helper.shorten_and_highlight(
        "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do 
eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        "lorem ipsum",
        50,
        "«",
        "»")
      shortened_and_highlighted.should_not include "«"
    end
  end
  
  describe "#build_regex" do
    it "builds regex from a string" do
      regex = helper.build_regex("lorem ipsum")
      regex.should == /(?<match>lorem\ ipsum)/i
    end
    
    it "removes quotes" do
      regex = helper.build_regex('"lorem ipsum"')
      regex.should == /(?<match>lorem\ ipsum)/i
    end
    
    it "removes field name prefixes" do
      regex = helper.build_regex("body:lorem")
      regex.should == /(?<match>lorem)/i
    end
    
    it "removes priority suffixes" do
      regex = helper.build_regex("lorem^2")
      regex.should == /(?<match>lorem)/i
    end
    
    it "removes asterisks" do
      regex = helper.build_regex("lorem*")
      regex.should == /(?<match>lorem)/i
    end
    
    it "escapes regex syntax" do
      regex = helper.build_regex("lorem|ipsum")
      regex.should == /(?<match>lorem\|ipsum)/i
    end
  end
end
