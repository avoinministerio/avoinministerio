class State < ActiveRecord::Base
  include Changelogger

  attr_accessible :administrator_id, :name

  has_many :ideas
  belongs_to :administrator

  validates_presence_of :name
  validates_uniqueness_of :name
end