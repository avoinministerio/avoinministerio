class Comment < ActiveRecord::Base
  include PublishingStateMachine
  include Changelogger

  attr_accessible :body

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  belongs_to :commentable, polymorphic: true

  default_scope order("created_at DESC")

  validates_length_of   :body,  minimum: 2

  validates :author_id,         presence: true
  validates :commentable_id,    presence: true
  validates :commentable_type,  presence: true

  def prepare_for_unpublishing
    if self.body.blank?
      self.body = "  "
    elsif self.body.length == 1
      self.body += " "
    end
  end
end
