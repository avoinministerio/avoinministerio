class Idea < ActiveRecord::Base
  include PublishingStateMachine
  include Changelogger
  extend FriendlyId

  include Tanker

  VALID_STATES = %w(idea draft proposal law)

  MAX_FB_TITLE_LENGTH = 100
  MAX_FB_DESCRIPTION_LENGTH = 500

  friendly_id :title, use: :slugged

  attr_accessible   :title, :body, :summary, :state, 
                    :comment_count, :vote_count, :vote_for_count, :vote_against_count, :vote_proportion, :vote_proportion_away_mid

  has_many :comments, as: :commentable
  has_many :votes
  has_many :articles
  has_many :expert_suggestions

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"

  validates :author_id, presence: true
  validates :title, length: { minimum: 5, message: "Otsikko on liian lyhyt." }
  validates :body,  length: { minimum: 5, message: "Kuvaa ideasi hieman tarkemmin." }
  validates :state, inclusion: { in: VALID_STATES }

#  tankit 'Ideas' do
  tankit 'BasicData' do
    conditions do
      published?
    end
    indexes :title
    indexes :summary
    indexes :body
    indexes :state
    indexes :author do
      self.author.first_name + " " + self.author.last_name
    end
    indexes :type do "idea" end
  end
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  def indexable?
    self.title.present?
  end


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
      update_vote_counts(0, option)
      KM.push("record", "voted",               {option: option, idea: self.id})
      KM.push("record", "vote change of mind", {option: option, idea: self.id})
    else
      votes.create(citizen: citizen, option: option)
      update_vote_counts(1, option)
      KM.push("record", "voted",               {option: option, idea: self.id})
      KM.push("record", "first vote on idea",  {option: option, idea: self.id})
    end
  end

  def update_vote_counts(new_votes, option)
    # following updates the counters regardless if option == 0 or == 1, note (option+1)%2 just flips 0->1 and 1->0
    prop = (vote_for_count + option.to_i).to_f / (vote_for_count + vote_against_count + new_votes)
    self.update_attributes(vote_count: vote_count + new_votes, 
                           vote_for_count: vote_for_count + option.to_i, 
                           vote_against_count: vote_against_count + (option.to_i+1) % 2, 
                           vote_proportion: prop,
                           vote_proportion_away_mid: (0.5 - prop).abs)
  end

  def voted_by?(citizen)
    votes.by(citizen).exists?
  end

  def vote_counts
    votes.group(:option).count
  end
end
