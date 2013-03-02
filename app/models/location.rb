class Location < ActiveRecord::Base
  attr_accessible :address, :name, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end
