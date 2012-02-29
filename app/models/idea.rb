class Idea < ActiveRecord::Base
  has_many :comments, as: :commentable
  has_many :votes
  
  default_scope order("created_at DESC")
  
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  
  state_machine :publish_state, initial: :published do
    event :publish do
      transition [ :in_moderation, :unpublished ] => :published
    end
    
    event :unpublish do
      transition [ :published ] => :unpublished
    end
    
    event :moderate do
      transition [ :published ] => :in_moderation
    end    
  end
    
  def vote(citizen, option)
    vote = votes.by(citizen).first
    if vote
      vote.update_attribute(:option, option) unless vote.option == option
    else
      votes.create(citizen: citizen, option: option)
    end
  end
  
  def voted_by?(citizen)
    votes.by(citizen).exists?
  end
  
  def self.published
    where(publish_state: "published")
  end
  
  def self.unpublished
    where(publish_state: "unpublished")
  end
  
  def self.in_moderation
    where(publish_state: "in_moderation")
  end
end
