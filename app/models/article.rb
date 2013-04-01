class Article < ActiveRecord::Base
  include PublishingStateMachine
  include Changelogger
  include Concerns::Indexing
  include Tanker
  extend FriendlyId

  attr_accessible :article_type, :title, :ingress, :body, :author, :citizen_id, :idea_id, :idea, :created_at, :updated_at

  VALID_ARTICLE_TYPES = %w(blog footer statement)

  friendly_id :title, use: :slugged

  belongs_to :idea
  belongs_to :author, class_name: "Citizen", foreign_key: "citizen_id"

  validates :article_type, inclusion: { in: VALID_ARTICLE_TYPES }
  validates :title, length: { minimum: 5 }

  if Rails.env == 'test'
    include Concerns::IndexingWrapperTest
  else
    include TankerMethods
    include Concerns::IndexingWrapper
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end
end
