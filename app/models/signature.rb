class Signature < ActiveRecord::Base
  VALID_STATES = %w(init query returned cancelled rejected)  # TODO: these are invalid at the moment, it's just initial, authenticated, and the last will be saved or error
  VALID_PUBLICITY_OPTIONS = %w(Normal Immediately)

  attr_protected :state
  attr_accessible :firstnames, :lastname, :birth_date, :occupancy_county, :vow, :signing_date, :stamp, :started
  attr_accessible :accept_general, :accept_non_eu_server, :accept_publicity, :accept_science

  belongs_to  :citizen
  belongs_to  :idea

  validates :citizen_id, presence: true
  validates :idea_id, presence: true
  validates :accept_general, acceptance: {accept: true, allow_nil: false}
  validates :accept_non_eu_server, acceptance: {accept: true, allow_nil: false}
  validates :accept_publicity, inclusion: VALID_PUBLICITY_OPTIONS

  def self.create_with_citizen_and_idea(citizen, idea)
    completed_signature = where(state: "signed", citizen_id: citizen.id, idea_id: idea.id).first
    if !completed_signature || ENV["Allow_Signing_Multiple_Times"]
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

      signature
    else
      nil
    end
  end
end
