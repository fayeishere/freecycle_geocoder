require 'freecycle_mail.rb'

class Location < ActiveRecord::Base
  attr_accessible :body, :data, :date, :latitude, :location, :longitude, :message_id, :subject
  geocoded_by :location
  after_validation :geocode, :if => :location_changed?

  # def to_json(*a)
  #   {
  #     'id'  => self.id,
  #     'subject' => self.subject,
  #     'location' => self.location,
  #     'latitude' => self.latitude,
  #     'longitude' => self.longitude
  #   }.to_json(*a)
  # end
end

