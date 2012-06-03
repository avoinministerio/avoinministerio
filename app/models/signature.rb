class Signature < ActiveRecord::Base
  VALID_STATES = %w(init query returned cancelled rejected)  # TODO: these are invalid at the moment, it's just initial, authenticated, and the last will be saved or error

  attr_accessible :state, :firstnames, :lastname, :birth_date, :occupancy_county, :vow, :signing_date, :stamp, :started

  belongs_to  :citizen
  belongs_to  :idea

  validates :citizen_id, presence: true
  validates :idea_id, presence: true
end
