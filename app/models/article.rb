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

  tankit index_name do
    conditions do
      published?
    end
    indexes :title
    indexes :ingress
    indexes :body
    indexes :author do
      self.author.first_name + " " + self.author.last_name
    end
    indexes :type do "article" end
    
    category :type do
      "article"
    end
  end
  after_save Concerns::IndexingWrapper.new
  after_destroy Concerns::IndexingWrapper.new


  def to_param
    "#{self.id}-#{self.slug}"
  end
end
