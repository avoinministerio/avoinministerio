class Idea < ActiveRecord::Base
  include PublishingStateMachine
  extend FriendlyId

  friendly_id :title, use: :slugged

  has_many :comments, as: :commentable
  has_many :votes
  has_many :articles

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"

  default_scope order("created_at DESC")

  def self.per_page
    25
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
