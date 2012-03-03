module PublishingStateMachine
  extend ActiveSupport::Concern

  included do
    state_machine :publish_state, initial: :published do
      event :publish do
        transition [ :in_moderation, :unpublished ] => :published
      end

      event :unpublish do
        transition [ :published ] => :unpublished
      end

      event :moderate do
        transition [ :published ] => :in_moderation
      end
    end

    scope :published, where(publish_state: "published")
    scope :unpublished, where(publish_state: "unpublished")
    scope :in_moderation, where(publish_state: "in_moderation")
  end
end