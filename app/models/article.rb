class Article < ActiveRecord::Base
  include Concerns::PublishingStateMachine
  include Concerns::Changelogger
  extend FriendlyId

  include Tanker

  VALID_ARTICLE_TYPES = %w(blog footer statement)

  friendly_id :title, use: :slugged

  belongs_to :idea
  belongs_to :author, class_name: "Citizen", foreign_key: "citizen_id"

  validates :article_type, inclusion: { in: VALID_ARTICLE_TYPES }
  validates :title, length: { minimum: 5 }

  tankit 'BasicData' do
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

  after_save :update_tank_indexes
  after_destroy :delete_tank_indexes


  def to_param
    "#{self.id}-#{self.slug}"
  end
end
