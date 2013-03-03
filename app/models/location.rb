class Location < ActiveRecord::Base
  attr_accessible :address, :name, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  KM_PER_MILE = 1.609344

  def self.m2km(miles)
    (miles.to_f * KM_PER_MILE).round(1)
  end  
end
