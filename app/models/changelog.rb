class Changelog < ActiveRecord::Base
  belongs_to :changer, polymorphic: true
  belongs_to :changelogged, polymorphic: true

  attr_accessible :changer_type, :changer, :changer_id, :changelogged_type, :changelogged_id, :change_type, :attribute_changes

  def self.per_page
    50
  end

  def attribute_changes
    YAML.load read_attribute(:attribute_changes)
  end
end
