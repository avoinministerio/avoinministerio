class TagSuggestion < ActiveRecord::Base
  belongs_to :tag
  belongs_to :idea
  belongs_to :user
  attr_accessible :tag_id, :idea_id, :citizen_id
end
