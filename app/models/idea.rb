class Idea < ActiveRecord::Base
  include PublishingStateMachine
  extend FriendlyId

  MAX_FB_TITLE_LENGTH = 100
  MAX_FB_DESCRIPTION_LENGTH = 500

  friendly_id :title, use: :slugged

  has_many :comments, as: :commentable
  has_many :articles
  has_many :votes
  has_many :articles

  default_scope order("created_at DESC")

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

  def vote_counts
    votes.group(:option).count
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
