class Changelog < ActiveRecord::Base
  belongs_to :idea, polymorphic: true
  belongs_to :comment, polymorphic: true
  belongs_to :article, polymorphic: true

  def attribute_changes
    YAML.load read_attribute(:attribute_changes)
  end
end
