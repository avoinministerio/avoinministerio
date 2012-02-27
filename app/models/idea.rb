class Idea < ActiveRecord::Base
  has_many :comments, as: :commentable
  has_many :articles
  has_many :votes
  
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  
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
end
