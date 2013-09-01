class Tag < ActiveRecord::Base
  attr_accessible :name, :status
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

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end

  def self.get_ids_by_name(params_tags)
    tag_ids = []
    tags_array = params_tags.split(",")
    tags_array.each do |tag_name|
      tag_ids << Tag.where(:name => tag_name).first.id
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
    @tag_vote != nil ? true : false
  end

  def voted_for?(idea_id, citizen_id)
    @tag_vote = TagVote.where(:idea_id => idea_id, :tag_id => self.id, :citizen_id => citizen_id).first
    @tag_vote.voted == "for" ? true : false
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
end