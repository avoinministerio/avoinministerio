class Idea < ActiveRecord::Base
  include PublishingStateMachine
  include Changelogger
  extend FriendlyId

  VALID_STATES = %w(idea draft proposal law)

  MAX_FB_TITLE_LENGTH = 100
  MAX_FB_DESCRIPTION_LENGTH = 500

  friendly_id :title, use: :slugged

  attr_accessible :title, :body, :summary, :state,
                  :collecting_started, :collecting_ended,
                  :collecting_start_date, :collecting_end_date, 
                  :additional_signatures_count, :additional_signatures_count_date, 
                  :target_count

  has_many :comments, as: :commentable
  has_many :votes
  has_many :articles
  has_many :expert_suggestions
  has_many :signatures

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"

  validates :author_id, presence: true
  validates :title, length: { minimum: 5, message: "Otsikko on liian lyhyt." }
  validates :body,  length: { minimum: 5, message: "Kuvaa ideasi hieman tarkemmin." }
  validates :state, inclusion: { in: VALID_STATES }

#  default_scope order("created_at DESC")

  def self.per_page
    25
  end

  def to_param
    "#{self.id}-#{self.slug}"
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
