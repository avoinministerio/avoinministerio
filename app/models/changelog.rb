class Changelog < ActiveRecord::Base
  belongs_to :changer, polymorphic: true
  belongs_to :changelogged, polymorphic: true

  def attribute_changes
    YAML.load read_attribute(:attribute_changes)
  end
end
