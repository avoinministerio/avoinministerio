class ForkedIdea < ActiveRecord::Base
  attr_accessible :author_id, :body, :summary, :title, :translated_idea_id, :pull_request_at, :is_closed

  belongs_to :translated_idea
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  belongs_to :citizen

  attr_accessible :author_id, :body, :idea_id, :language, :summary, :title

  validates_uniqueness_of :translated_idea_id, :scope => [:author_id]
end
