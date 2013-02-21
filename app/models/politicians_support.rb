class PoliticiansSupport < ActiveRecord::Base
  attr_accessible :idea_id, :citizen_id, :vote
  validates_uniqueness_of :idea_id, :scope => :citizen_id
  belongs_to :idea
  belongs_to :citizen
end
