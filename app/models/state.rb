class State < ActiveRecord::Base
  attr_accessible :administrator_id, :name, :rank, :city_id

  has_many :ideas, :dependent => :destroy
  belongs_to :administrator

  validates_presence_of :administrator_id, :name, :city_id
  validates_uniqueness_of :name, :scope => [:rank, :city_id]
end