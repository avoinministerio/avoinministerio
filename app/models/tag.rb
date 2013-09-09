class Tag < ActiveRecord::Base
  attr_accessible :name, :status, :is_location

  validates :name, :uniqueness => {:scope => :is_location}

  has_many :taggings
  has_many :tag_votes
  has_many :tag_suggestions
  has_many :ideas, through: :taggings

  def self.tokens(query)
    tags = where("name like ?", "%#{query}%")
    if tags.empty?
      [{id: "<<<#{query}>>>", name: "#{query}"}]
    else
      tags
    end
  end

  def self.ids_from_tokens(tokens, is_location)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1.titleize, is_location: (is_location || false)).id }
    tokens.split(',')
  end

  def self.get_ids_by_name(data_tags)
    tag_ids = []
    tags_array = data_tags.split(",")
    tags_array.each do |tag_name|
      tag = Tag.where(:name => tag_name)
      tag_ids << tag.first.id if tag.first
    end
    tag_ids
  end

  def score(idea_id)
    Tagging.where(:idea_id => idea_id, :tag_id => self.id).first.score
  end

  def status(idea_id)
    Tagging.where(:idea_id => idea_id, :tag_id => self.id).first.status
  end

  def approved?(idea_id)
    Tagging.where(:idea_id => idea_id, :tag_id => self.id).first.status == "approved"
  end

  def suggested?(idea_id)
    Tagging.where(:idea_id => idea_id, :tag_id => self.id).first.status == "suggested"
  end

  def vote_limit?(idea_id)
    Tagging.where(:idea_id => idea_id, :tag_id => self.id).first.score >= 20
  end

  def citizen_voted?(idea_id, citizen_id)
    @tag_vote = TagVote.where(:idea_id => idea_id, :tag_id => self.id, :citizen_id => citizen_id).first
    !!@tag_vote
  end

  def voted_for?(idea_id, citizen_id)
    @tag_vote = TagVote.where(:idea_id => idea_id, :tag_id => self.id, :citizen_id => citizen_id).first
    @tag_vote.voted == "for"
  end

  def self.vote_for(idea_id, tag_id, citizen_id)
    @tagging = Tagging.where(:idea_id => idea_id, :tag_id => tag_id).first
    TagVote.create(:tag_id => tag_id, :idea_id => idea_id, :citizen_id => citizen_id, :voted => "for")
    @tagging.increase_score
  end

  def self.vote_against(idea_id, tag_id, citizen_id)
    @tagging = Tagging.where(:idea_id => idea_id, :tag_id => tag_id).first
    TagVote.create(:tag_id => tag_id, :idea_id => idea_id, :citizen_id => citizen_id, :voted => "against")
    @tagging.decrease_score
  end
  
  def self.tags_suggestions(data)
    tag_ids = Tag.ids_from_tokens(data[:idea]['suggested_tags'], data[:idea]['is_location'])
    idea = Idea.find(data[:id])
    idea.count_suggested_tags(data[:idea]['citizen_id'])
    idea.add_suggested_tags(tag_ids, data[:idea]['citizen_id'])
    idea
  end
end