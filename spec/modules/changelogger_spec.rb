require 'spec_helper'

describe Changelogger do
  class CreateChangeloggableItems < ActiveRecord::Migration
    def up
      create_table :changeloggable_items do |t|
        t.string :title
        t.timestamps
      end
    end
    def down
      drop_table :changeloggable_items
    end
  end

  class ChangeloggableItem < ActiveRecord::Base
    include Changelogger
  end

  before :all do
    silence_stream(STDOUT) {
      CreateChangeloggableItems.new.up
    }
  end

  after :all do
    silence_stream(STDOUT) {
      CreateChangeloggableItems.new.down
    }
  end

  before :each do
    @item = ChangeloggableItem.new title: "Log me!"
  end

  it "should log creates" do
    lambda {
      @item.save!
    }.should change(Changelog, :count).by(1)
    cl = @item.changelogs.first
    cl.changelogged.should == @item
    cl.change_type.should == "create"
    cl.attribute_changes['title'].should == [nil, "Log me!"]
  end

  it "should log updates" do
    @item.save!
    lambda {
      @item.title = "I just got updated!"
      @item.save!
    }.should change(Changelog, :count).by(1)
    cl = @item.changelogs.last
    cl.change_type.should == "update"
    cl.attribute_changes['title'].should == ["Log me!", "I just got updated!"]
  end

  it "should log destroys" do
    @item.save!
    lambda {
      @item.destroy
    }.should change(Changelog, :count).by(1)
    cl = Changelog.last
    cl.change_type.should == "destroy"
    cl.attribute_changes.should == {}
  end

  it "should log a citizen changer" do
    citizen = Factory(:citizen)
    Thread.current[:changer] = citizen
    lambda {
      @item.save!
    }.should change(Changelog, :count).by(1)
    cl = Changelog.last
    cl.changer.should == citizen
  end

  it "should log an administrator changer" do
    administrator = Factory(:administrator)
    Thread.current[:changer] = administrator
    lambda {
      @item.save!
    }.should change(Changelog, :count).by(1)
    cl = Changelog.last
    cl.changer.should == administrator
  end
end
