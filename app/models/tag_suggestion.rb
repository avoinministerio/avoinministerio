class TagSuggestion < ActiveRecord::Base
  belongs_to :tag
  belongs_to :idea
  belongs_to :user, :polymorphic => true
  attr_accessible :tag_id, :idea_id, :user_id, :user_type
  validates_uniqueness_of :tag_id, :scope => [:user_id, :user_type, :idea_id]
end
