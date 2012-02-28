class Vote < ActiveRecord::Base
  belongs_to :idea
  belongs_to :citizen
  
  def self.by(citizen)
    where(citizen_id: citizen && citizen.id || nil)
  end
  
  def self.in_favor
    where(option: 1)
  end
  
  def self.against
    where(option: 0)
  end
end
