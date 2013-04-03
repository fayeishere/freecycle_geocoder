require 'freecycle_mail.rb'

class Location < ActiveRecord::Base
  attr_accessible :body, :data, :date, :latitude, :location, :longitude, :message_id, :subject
  geocoded_by :location
  after_validation :geocode, :if => :location_changed?
end

