require 'spec_helper'

describe Changelogger do
  module Connections
    def self.extended(host)
      host.connection.execute <<-eosql
          CREATE TABLE #{host.table_name} (
            #{host.primary_key} integer PRIMARY KEY AUTOINCREMENT,
            associated_model_id integer,
            mockable_model_id integer,
            nonexistent_model_id integer,
            title string
          )
        eosql
    end
  end

  class ChangeloggableItem < ActiveRecord::Base
    extend Connections
    include Changelogger

    # attr_accessor :title, :created_at, :updated_at
  end

  after :all do
    ChangeloggableItem.connection.execute "DROP TABLE changeloggable_items"
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
