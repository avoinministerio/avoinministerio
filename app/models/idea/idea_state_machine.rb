class Idea
  module IdeaStateMachine
    extend ActiveSupport::Concern

    def check_collecting_booleans
      self.errors.add(:colleacting_started, ::I18n.t('must be true or false')) unless ([true,false].include? self.collecting_started)
      self.errors.add(:colleacting_ended, ::I18n.t('must be true or false')) unless ([true,false].include? self.collecting_started)
    end

    private :check_collecting_booleans

    def check_collecting_dates
      if self.collecting_started
        self.errors.add(:collecting_start_date, ::I18n.t('must be a valid datetime')) unless self.collecting_start_date.kind_of? Date
        self.errors.add(:collecting_end_date, ::I18n.t('must be a valid datetime')) unless self.collecting_start_date.kind_of? Date
        if self.collecting_start_date.kind_of?(Date) and self.collecting_end_date.kind_of?(Date)
          self.errors.add(:collecting_end_date, ::I18n.t("must be greater than collecting start date")) if ((self.collecting_end_date <=> self.collecting_start_date) == -1)
        end
      end
    end

    private :check_collecting_dates

    def is_valid_law?
      self.errors.add(:collecting_ended, "collecting have not been started") unless collecting_started == true
      self.errors.add(:collecting_ended, "collecting must been ended") unless collecting_ended == true
    end

    private :is_valid_law?

    included do
      state_machine :state, initial: :idea do

        state :draft do
          validates :title, presence: true, uniqueness: {case_sensitve: false}
          validates :body, presence: true, uniqueness: {case_sensitve: false}
        end

        event :set_as_idea do
          transition any => :idea
        end

        event :set_as_draft do
          transition any => :draft
        end

        after_failure on: :set_as_draft, do: :set_as_idea

        state :proposal do
          validate :check_collecting_booleans
          validate :check_collecting_dates
        end

        event :set_as_proposal do
          transition any => :proposal
        end

        after_failure on: :set_as_proposal, do: :set_as_draft

        state :law do
          validates :title, presence: true, uniqueness: {case_sensitve: false}
          validates :body, presence: true, uniqueness: {case_sensitve: false}
          validate :check_collecting_booleans
          validate :check_collecting_dates
          validate :is_valid_law?
        end

        event :set_as_law do
          transition [:proposal] => :law
        end

        after_failure on: :set_as_law, do: :set_as_proposal

      end
    end
  end
end
