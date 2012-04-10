class Signature < ActiveRecord::Base
  VALID_STATES = %w(init query returned cancelled rejected)

  attr_accessible :state

  belongs_to  :citizen
  belongs_to  :idea

  validates :citizen_id, presence: true
  validates :idea_id, presence: true
end
