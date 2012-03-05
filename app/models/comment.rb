class Comment < ActiveRecord::Base
  include PublishingStateMachine

  attr_accessible :body

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  belongs_to :commentable, polymorphic: true

  default_scope order("created_at DESC")

  validates_length_of   :body,  minimum: 2

  validates :author_id,         presence: true
  validates :commentable_id,    presence: true
  validates :commentable_type,  presence: true
end
