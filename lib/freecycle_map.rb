require 'geocoder'

class Location < ActiveRecord::Base
  extend ::Geocoder::Model::ActiveRecord
  
#  attr_accessible :address, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode, :if => :address_changed

  def initialize(address)
    @address = address
  end
end
