class TranslatedIdea < ActiveRecord::Base
  belongs_to :idea
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  attr_accessible :author_id, :body, :idea_id, :language, :summary, :title

  validates_uniqueness_of :idea_id, :scope => [:language]
end
