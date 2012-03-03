# encoding: UTF-8

require 'spec_helper'

describe Admin::AdminHelper do  
  describe "#classes_for_nav" do
    it "does something" do
      helper.stub(:controller_name).and_return("ideas")
      helper.classes_for_nav("ideas").should == "active"      
    end
  end
end