class Country < ActiveRecord::Base
  attr_accessible :id, :iso, :name

  has_many :regions, :dependent => :destroy

  validates_presence_of  :iso, :name
end
