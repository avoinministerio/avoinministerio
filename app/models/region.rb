class Region < ActiveRecord::Base
  attr_accessible :id, :country_id, :iso, :name

  has_many :cities, :dependent => :destroy
  belongs_to :country

  validates_presence_of  :country_id, :iso, :name
end
