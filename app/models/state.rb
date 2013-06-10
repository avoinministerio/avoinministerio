class State < ActiveRecord::Base
  attr_accessible :administrator_id, :name, :city_id, :rank

  has_many :ideas, :dependent => :destroy
  belongs_to :city
  belongs_to :administrator

  validates_presence_of :name, :city_id, :rank
  validates_uniqueness_of :name, :scope => :city_id
  validates_uniqueness_of :city_id, :scope => :rank
end