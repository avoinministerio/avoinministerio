class Signature < ActiveRecord::Base
  VALID_STATES = %w(init query returned cancelled rejected)

  attr_accessible :state, :fullname, :birth_date, :occupancy_county, :vow, :signing_date

  belongs_to  :citizen
  belongs_to  :idea

  validates :citizen_id, presence: true
  validates :idea_id, presence: true
end
