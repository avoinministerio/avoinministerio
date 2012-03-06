class Idea < ActiveRecord::Base
  include PublishingStateMachine
  extend FriendlyId

  MAX_FB_TITLE_LENGTH = 100
  MAX_FB_DESCRIPTION_LENGTH = 500

  friendly_id :title, use: :slugged

  attr_accessible :title, :body, :summary

  has_many :comments, as: :commentable
  has_many :votes
  has_many :articles

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"

  validates :author_id, presence: true
  validates :title, length: { minimum: 5, message: "Otsikko on liian lyhyt." }
  validates :body,  length: { minimum: 5, message: "Kuvaa ideasi hieman tarkemmin." }

  default_scope order("created_at DESC")

  def self.per_page
    25
  end

  def vote(citizen, option)
    vote = votes.by(citizen).first
    KM.identify(citizen)
    if vote
      vote.update_attribute(:option, option) unless vote.option == option
      KM.push("record", "voted",               {option: option, idea: self.id})
      KM.push("record", "vote change of mind", {option: option, idea: self.id})
    else
      KM.push("record", "voted",               {option: option, idea: self.id})
      KM.push("record", "first vote on idea",  {option: option, idea: self.id})
      votes.create(citizen: citizen, option: option)
    end
  end

  def voted_by?(citizen)
    votes.by(citizen).exists?
  end

  def vote_counts
    votes.group(:option).count
  end
end
