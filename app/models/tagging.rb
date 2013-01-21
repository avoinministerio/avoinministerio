class Tagging < ActiveRecord::Base
  attr_accessible :score, :status, :tag_id, :idea_id

  belongs_to :tag
  belongs_to :idea

  before_create :basic_scores, :check_status
  before_save :check_status
  after_save :remove

  def basic_scores
    if self.score == nil && self.status == nil
      self.score = 5
      self.status = "approved"
    end
  end

  def increase_score
    self.update_attributes(:score => self.score + 1)
  end

  def decrease_score
    self.update_attributes(:score => self.score - 1)
  end
  
  def check_status
    if self.score != nil
      if self.score >= 5
        self.status = "approved"
      else
        self.status = "suggested"
      end
    end
  end

  def remove
    if self.score <= -5
      self.destroy
    end
  end
end
