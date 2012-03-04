class Changelog < ActiveRecord::Base
  belongs_to :changer, polymorphic: true
  belongs_to :changelogged, polymorphic: true

  default_scope order(created_at: :desc)

  def self.per_page
    100
  end

  def attribute_changes
    YAML.load read_attribute(:attribute_changes)
  end
end
