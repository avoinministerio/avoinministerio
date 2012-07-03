require 'spec_helper'

describe Concerns::FileStorage do

  class Dummy
    include Concerns::FileStorage

    def self.fog_directory_name
      "dummy"
    end
  end

  describe "Class Methods" do
    describe "#fog_directory" do
      it "should return connection to given bucket" do
        Dummy.send(:fog_directory).class.should == Fog::Storage::AWS::Directory
        Dummy.send(:fog_directory).key.should == "dummy"
      end
    end

    describe "#fog_upload" do
      it "should upload new file to cloud" do
        sample_file = Dummy.store_file('sample.csv', 'loremlipsum')
        sample_file.class.should == Fog::Storage::AWS::File
        sample_file.key.should == 'sample.csv'
      end

      it "should set expires time to file" do
        expires_at = 11.minutes.from_now
        sample_file = Dummy.store_file('sample.csv', 'loremlipsum', expires_at)
        sample_file.expires.should == expires_at
      end
    end

    describe "#get_file" do
      it "should return url to file" do
        expires_at = 20.minutes.from_now
        sample_file = Dummy.store_file('sample.csv', 'loremlipsum')
        Dummy.get_file('sample.csv', expires_at).should == sample_file.url(expires_at)
      end
    end

    describe "#fog_destroy" do
      it "should destroy existing file" do
        sample_file = Dummy.store_file('sample.csv', 'loremlipsum')
        Dummy.delete_file('sample.csv').should == true
      end
    end
  end



end