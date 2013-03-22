class TranslatedIdea < ActiveRecord::Base
  include Changelogger
  
  belongs_to :idea
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  
  has_many :forked_ideas, :dependent => :destroy
  attr_accessible :author_id, :body, :idea_id, :language, :summary, :title
  
  validates_uniqueness_of :idea_id, :scope => [:language]
  
  def collecting_ended
    self.idea.collecting_ended
  end
  
  def signatures
    self.idea.signatures
  end
  
  def additional_signatures_count
    self.idea.additional_signatures_count
  end
  
  def vote_counts
    self.idea.vote_counts
  end
  
  def comments
    self.idea.comments
  end
  
  def collecting_start_date
    self.idea.collecting_start_date
  end
  
  def collecting_end_date
    self.idea.collecting_end_date
  end
end
