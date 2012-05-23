class Comment < ActiveRecord::Base
  include PublishingStateMachine
  include Changelogger

  include Tanker

  attr_accessible :body

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  belongs_to :commentable, polymorphic: true

  default_scope order("created_at DESC")

  validates_length_of   :body,  minimum: 2

  validates :author_id,         presence: true
  validates :commentable_id,    presence: true
  validates :commentable_type,  presence: true

  tankit 'Comments' do
    # add conditions do .. end
    indexes :body
    indexes :author do
      self.author.first_name + " " + self.author.last_name
    end
  end
  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes

  def prepare_for_unpublishing
    if self.body.blank?
      self.body = "  "
    elsif self.body.length == 1
      self.body += " "
    end
  end

  after_create :increment_idea_comment_count
  def increment_idea_comment_count
    update_idea_comment_count(1)
  end

  after_destroy :decrement_idea_comment_count
  def decrement_idea_comment_count
    update_idea_comment_count(-1)
  end

  def update_idea_comment_count(incrdecr)
    self.commentable.update_attributes(comment_count: self.commentable.comment_count + incrdecr) if self.commentable_type == "Idea"
  end

end
