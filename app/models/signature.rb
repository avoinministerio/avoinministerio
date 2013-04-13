class Signature < ActiveRecord::Base
  VALID_STATES = %w(init query returned cancelled rejected)  # TODO: these are invalid at the moment, it's just initial, authenticated, and the last will be saved or error
  VALID_PUBLICITY_OPTIONS = %w(Normal Immediately)

  attr_accessible :state, :firstnames, :lastname, :birth_date, :occupancy_county, :vow, :signing_date, :stamp, :started
  attr_accessible :service
  attr_accessible :accept_general, :accept_non_eu_server, :accept_publicity, :accept_science, :citizen_id, :idea_id

  before_save :fail_if_citizen_signed_idea?

  belongs_to  :citizen
  belongs_to  :idea

  validates :citizen_id, presence: true

  validates :idea_id, presence: true
  validates :accept_general, acceptance: {accept: true, allow_nil: false}
  validates :accept_non_eu_server, acceptance: {accept: true, allow_nil: false}
  validates :accept_science, acceptance: {accept: true, allow_nil: true}
  validates :accept_publicity, inclusion: VALID_PUBLICITY_OPTIONS

  include SignaturesParser

  def self.create_with_citizen_and_idea(citizen, idea)
    completed_signature = where(state: "signed", citizen_id: citizen.id, idea_id: idea.id).first
    if !completed_signature || ENV["ALLOW_SIGNING_MULTIPLE_TIMES"]
      signature = new() do |s|
        s.citizen           = citizen
        s.firstnames        = citizen.first_names
        s.lastname          = citizen.last_name
        s.idea              = idea
        s.idea_title        = idea.title
        s.idea_date         = idea.updated_at
        s.state             = "initial"
        s.stamp             = ensure_stamp_length(DateTime.now.strftime("%Y%m%d%H%M%S") + rand(100000).to_s, 20)
        s.started           = Time.now
        s.occupancy_county  = ""
        s.service           = nil
      end

      signature
    else
      nil
    end
  end

  def self.find_for(citizen, signature_id)
    signature = find(signature_id)
    if signature and signature.citizen.id == citizen.id
      signature
    else
      nil
    end
  end

  def self.signed_only
    where(:state => "signed")
  end

  def self.for_idea(my_idea_id)
    where(:idea_id => my_idea_id)
  end

  private

  def self.ensure_stamp_length(stamp, digits = 20)
    stamp = stamp.dup
    while stamp.length < digits
      stamp.concat(rand(10).to_s)
    end
    stamp
  end

  def fail_if_citizen_signed_idea?
    if detected_signature = Signature.signed_only.for_idea(self.idea_id).find_by_citizen_id(self.citizen_id)
      if self.id != detected_signature.id
        self.errors.add :base, "you signed this idea earlier"
        false
      end
    else
      true
    end
  end

end
