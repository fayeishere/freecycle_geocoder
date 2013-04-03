#### freecycle mail app


$LOAD_PATH << File.join(File.dirname(__FILE__))

require 'mail_config'
require 'mail'
require 'json'

# http://blog.rubybestpractices.com/posts/gregory/033-issue-4-configurable.html
# http://metabates.com/2011/06/28/lets-say-goodbye-to-yaml-for-configuration-shall-we/


# 'lib/mail_config.rb should be a ruby file in the following format:

# module FreeCycleMap
#   USER_CONFIG = {
#     :user_name => "username",
#     :password => "password" }
#   MAIL_CONFIG = {
#     :server => "mailserver",
#     :group => "freecycle mailing list email address" }
# end

# !!! FIXME [wc 2013-03-13]: This is somewhat bad

credentials = {
  :port => 993,
  :enable_ssl => true
}

credentials[:address] = FreeCycleMap::MAIL_CONFIG[:server]
credentials[:user_name] = FreeCycleMap::USER_CONFIG[:user_name]
credentials[:password] = FreeCycleMap::USER_CONFIG[:password]



Mail.defaults { retriever_method :imap, credentials }

# Now we are ready to retrieve mail and work with them.

def search_for_location (subject)
  # Search a subject for possible locations

  # first check for location in parentheses
  location = subject.scan(/\(.*\)/).first
  unless location.nil?
    if location.is_a? String
      location = location[1..-2]
    end
  end

  # check for location after one or more dashes
  if location.nil?
    s = subject.split(/-+/).last
    s == subject ? location = nil : location = s.strip
  end

  # check for location after the last word "in"
  if location.nil?
    s = subject.split(/in /).last
    s == subject ? location = nil : location = s.strip
  end

  # raise an error if somehow the location in string is neither nil or
  # string
  unless location.nil?
    unless location.is_a? String
      raise "Location, #{location}, neither nil or String."
    end
    location += ", Portland, Oregon"
  end
  return location
end

# needs to add portland, or to search location
# http://rubydoc.info/gems/mail

def make_email_data(email)
  data = {}
  location = search_for_location(email.subject)
  data[:date] = email.date
  data[:message_id] = email.message_id
  data[:subject] = email.subject
  data[:location] = location
  data[:body] = email.body
  Location.create(:date => email.date, :message_id => email.message_id, :subject => email.subject, :body => email.body, :location => location)

  # Location.create(:subject => email.subject)
  # Location.create(:body => email.body)


  return data
end

def recent_offers (count=nil)
  # Returns a list of subject lines with the word 'offer' in them.
  return Mail.find({
                     :order => :desc,
                     :what => :last,
                     :count => count,
                     :keys => ["SUBJECT", "OFFER"]
                   }).map { |email| make_email_data(email) }
end

def recent_offers_web_data
  # Return a json string of recent offer data
  recent_offers().to_json
  # @subject = Location.new(params[:subject])
  #       itsaved = @subject.save
end