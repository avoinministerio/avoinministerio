module Changelogger
  extend ActiveSupport::Concern

  included do
    has_many :changelogs, as: :changelogged

    after_create { changelog_for!(:create) }
    before_update { changelog_for!(:update) }
    before_destroy { changelog_for!(:destroy) }

    def changelog_for!(action)
      self.changelogs.create!(
          changer: Thread.current[:changer], # not actually thread-safe, but enough for our needs
          changelogged_type: self.class,
          changelogged_id: self.id,
          change_type: action,
          attribute_changes: self.changes.to_yaml
        )
    end
  end
end
