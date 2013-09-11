class Country < ActiveRecord::Base
  attr_accessible :id, :iso, :name

  has_many :regions, :dependent => :destroy
  has_many :cities, :through => :regions

  validates_presence_of  :iso, :name
end
