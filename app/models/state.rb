class State < ActiveRecord::Base
  attr_accessible :administrator_id, :name

  has_many :ideas, :dependent => :destroy
  belongs_to :administrator

  validates_presence_of :name
  validates_uniqueness_of :name
end