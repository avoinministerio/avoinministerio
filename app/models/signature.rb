class Signature < ActiveRecord::Base
  VALID_STATES = %w(init query returned cancelled rejected)  # TODO: these are invalid at the moment, it's just initial, authenticated, and the last will be saved or error

  attr_accessible :state, :firstnames, :lastname, :birth_date, :occupancy_county, :vow, :signing_date, :stamp, :started
  attr_accessible :accept_general, :accept_non_eu_server, :accept_publicity, :accept_science

  belongs_to  :citizen
  belongs_to  :idea

  validates :citizen_id, presence: true
  validates :idea_id, presence: true

  def self.create_with_citizen_and_idea(citizen, idea)
    signature = new() do |s|
      s.citizen = citizen
      s.firstnames = citizen.first_names
      s.lastname = citizen.last_name
      s.idea = idea
      s.idea_title = idea.title
      s.idea_date = idea.updated_at
      s.state = "initial"
      s.stamp = DateTime.now.strftime("%Y%m%d%H%M%S") + rand(100000).to_s
      s.started = Time.now
      s.occupancy_county = ""
    end

    signature.save!
    signature
  end
end
