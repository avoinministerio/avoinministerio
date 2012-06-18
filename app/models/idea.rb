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
                    :comment_count, :vote_count, :vote_for_count, :vote_against_count, 
                    :vote_proportion, :vote_proportion_away_mid,
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
    
    category :type do
      "idea"
    end
    
    category :state do
      state
    end
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
      update_vote_counts(option, vote.option)
      vote.update_attribute(:option, option) unless vote.option == option
      KM.push("record", "voted",               {option: option, idea: self.id})
      KM.push("record", "vote change of mind", {option: option, idea: self.id})
    else
      update_vote_counts(option, nil)
      votes.create(citizen: citizen, option: option)
      KM.push("record", "voted",               {option: option, idea: self.id})
      KM.push("record", "first vote on idea",  {option: option, idea: self.id})
    end
  end
  
  def update_vote_counts(option, old_option)
    if old_option == nil
      self.vote_count += 1
    elsif old_option == 0
      # decrement vote counter to keep the citizen from voting multiple times
      self.vote_against_count -= 1
    else
      # decrement vote counter
      self.vote_for_count -= 1
    end
    
    if option == 0
      self.vote_against_count += 1
    else
      self.vote_for_count += 1
    end
    
    self.vote_proportion = self.vote_for_count.to_f / self.vote_count
    self.vote_proportion_away_mid = (0.5 - self.vote_proportion).abs
    
    self.save
  end

  def voted_by?(citizen)
    votes.by(citizen).exists?
  end

  def vote_counts
    votes.group(:option).count
  end
end
