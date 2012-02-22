class Vote < ActiveRecord::Base
  belongs_to :idea
  belongs_to :citizen
  
  def self.by(citizen)
    where(citizen_id: citizen.id).first
  end
end
