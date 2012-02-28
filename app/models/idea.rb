class Idea < ActiveRecord::Base
  has_many :comments, as: :commentable
  has_many :articles
  has_many :votes
  
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  
  def vote(citizen, option)
    vote = votes.by(citizen).first
    if vote
      REDIS.decr "idea:#{self.id}:vote:#{vote.option}"
      vote.update_attribute(:option, option) unless vote.option == option
      REDIS.incr "idea:#{self.id}:vote:#{vote.option}"
    else
      votes.create(citizen: citizen, option: option)
      REDIS.incr "idea:#{self.id}:vote:#{option}"
    end
  end
  
  def voted_by?(citizen)
    votes.by(citizen).exists?
  end
end
