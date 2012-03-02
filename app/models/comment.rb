class Comment < ActiveRecord::Base
  include PublishingStateMachine

  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
  belongs_to :commentable, polymorphic: true
  
  default_scope order("created_at DESC")
  
  validates :body, presence: true
  
  validates :author_id,         presence: true
  validates :commentable_id,    presence: true
  validates :commentable_type,  presence: true
end
