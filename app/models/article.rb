class Article < ActiveRecord::Base
  include PublishingStateMachine
  include Changelogger
  include Concerns::Indexing
  include Tanker
  extend FriendlyId

  VALID_ARTICLE_TYPES = %w(blog footer statement)

  friendly_id :title, use: :slugged

  belongs_to :idea
  belongs_to :author, class_name: "Citizen", foreign_key: "citizen_id"

  validates :article_type, inclusion: { in: VALID_ARTICLE_TYPES }
  validates :title, length: { minimum: 5 }

  if Rails.env == 'testjs'
    include Concerns::IndexingWrapperTest
  else
    include TankerMethods
    include Concerns::IndexingWrapper
  end

  def to_param
    "#{self.id}-#{self.slug}"
  end
end
