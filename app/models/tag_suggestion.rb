class TagSuggestion < ActiveRecord::Base
  belongs_to :tag
  belongs_to :idea
  belongs_to :user
  attr_accessible :tag_id, :idea_id, :citizen_id
  validates_uniqueness_of :tag_id, :scope => [:citizen_id, :idea_id]
end
