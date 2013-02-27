class Idea < ActiveRecord::Base
  include PublishingStateMachine
  include Changelogger
  include Concerns::Indexing
  include Tanker
  extend FriendlyId

#  VALID_STATES = %w(idea draft proposal law)
  
  TAG_LIMIT = 5
  MAX_FB_TITLE_LENGTH = 100
  MAX_FB_DESCRIPTION_LENGTH = 500

  friendly_id :title, use: :slugged

  attr_accessible   :title, :body, :summary, :state_id, :tag_list, 
                    :comment_count, :vote_count, :vote_for_count, :vote_against_count, 
                    :vote_proportion, :vote_proportion_away_mid,
                    :collecting_in_service, 
                    :collecting_started, :collecting_ended,
                    :collecting_start_date, :collecting_end_date, 
                    :additional_signatures_count, :additional_signatures_count_date, 
                    :additional_collecting_service_urls,  # using !!! as a separator between multiple urls
                    :target_count, :updated_content_at

  attr_reader :suggested_politicians_for, :suggested_politicians_against

  attr_reader :file_name
  attr_reader :tag_list, :suggested_tags

  has_many :comments, as: :commentable
  has_many :votes
  has_many :articles
  has_many :expert_suggestions
  has_many :signatures
  has_many :documents
  has_many :politicians_support
  has_many :taggings
  has_many :tag_votes
  has_many :tag_suggestions
  has_many :tags, through: :taggings

  has_many :politicians_support

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  belongs_to :state

  validates :author_id, presence: true
  validates :title, length: { minimum: 5, message: "Otsikko on liian lyhyt." }
  validates :body,  length: { minimum: 5, message: "Kuvaa ideasi hieman tarkemmin." }
#  validates :state, inclusion: { in: VALID_STATES }

  tankit index_name do
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
  after_save Concerns::IndexingWrapper.new
  after_destroy Concerns::IndexingWrapper.new

  def state
    State.find(state_id).name
  end

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
    if vote
      update_vote_counts(option, vote.option)
      vote.update_attribute(:option, option) unless vote.option == option
    else
      update_vote_counts(option, nil)
      votes.create(citizen: citizen, option: option)
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
    
    if option == "0"
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
    # votes.group(:option).count   # => returns counts like:  {0=>37, 1=>45}
    {0 => vote_against_count, 1 => vote_for_count}
  end
  
  def signatures_per_day
    signatures_count = signatures.where(state: "signed").count
    total_signatures = signatures_count + additional_signatures_count
    dates_collected = (today_date - collecting_start_date + 1).to_i
    (total_signatures.to_f) / dates_collected
  end
  
  def can_be_signed?
    started   = collecting_started ||
      (collecting_start_date && collecting_start_date <= today_date)
    ended     = collecting_ended   ||
      (collecting_end_date && collecting_end_date < today_date)
    started and (not ended) and collecting_in_service and state == "proposal"
  end
  
  def adopted_by
    if self.politicians_support != []
      Citizen.find(self.politicians_support.first.citizen_id)
    end
  end

  def supported_by
    politicians = []
    self.politicians_support.each do |support|
      if support.vote == "for"
        politicians << Citizen.find(support.citizen_id)
      end
    end
    return (politicians - [self.adopted_by])
  end

  def unsupported_by
    politicians = []
    self.politicians_support.each do |unsupport|
      if unsupport.vote == "against"
        politicians << Citizen.find(unsupport.citizen_id)
      end
    end
    return politicians
  end

  def self.tagged_with(name)
    Tag.find_by_name!(name).ideas
  end

  def self.all_tags
    Tag.select("tags.id, tags.name, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  end

  def self.tag_counts
    Tag.select("tags.id, tags.name, count(taggings.tag_id) as count").where(:is_location => false).joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  end

  def self.location_tag_counts
    Tag.select("tags.id, tags.name, count(taggings.tag_id) as count").where(:is_location => true).joins(:taggings).group("taggings.tag_id, tags.id, tags.name")
  end

  def possible_tags
    Idea.all_tags - self.tags
  end
  
  #def tag_list
  #  tags.map(&:name).join(", ")
  #end

  def tag_list=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end
  
  #tag_ids -> array of tag ids
  def self.find_similar(tag_ids)
    Idea.all( :conditions => ['tags.id IN (?)', tag_ids], 
              :joins      => :tags, 
              :group      => 'ideas.id', 
              :having     => ['COUNT(*) >= ?', tag_ids.length])
  end

  def count_suggested_tags(citizen_id)
    TagSuggestion.where(:citizen_id => citizen_id, :idea_id => self.id).all.count
  end

  def add_suggested_tags(tag_ids, citizen_id)
    tag_ids.each do |tag_id|
      if count_suggested_tags(citizen_id) < TAG_LIMIT
        Tagging.create(:tag_id => tag_id, :idea_id => self.id, :status => "suggested", :score => "1")
        TagSuggestion.create(:tag_id => tag_id, :idea_id => self.id, :citizen_id => citizen_id)
      end
    end
  end
end
