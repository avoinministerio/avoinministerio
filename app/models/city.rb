class City < ActiveRecord::Base
  attr_accessible :id, :name, :region_id

  has_many :states, :dependent => :destroy
  belongs_to :region

  validates_presence_of :name, :region_id
end
