#### freecycle mail app


$LOAD_PATH << File.join(File.dirname(__FILE__))

# require 'mail_config'
require 'mail'
require 'json'

# http://blog.rubybestpractices.com/posts/gregory/033-issue-4-configurable.html
# http://metabates.com/2011/06/28/lets-say-goodbye-to-yaml-for-configuration-shall-we/


module FreeCycleConfig
  # Add env variables locally
    USER_CONFIG = {
      :user_name => ENV['FCM_USERNAME'],
      :password => ENV['FCM_PASSWORD'] }
    MAIL_CONFIG = {
      :server => ENV['FCM_SERVER'],
      :group => ENV['FCM_GROUP'] }
    LOCATION_SPECIFIER = ENV['FCM_LOCATION']
end

module FreeCycleMail

  LOCATION_SPECIFIER = FreeCycleConfig::LOCATION_SPECIFIER

  CREDENTIALS = {
    :port => 993,
    :enable_ssl => true
  }

  CREDENTIALS[:address]   = FreeCycleConfig::MAIL_CONFIG[:server]
  CREDENTIALS[:user_name] = FreeCycleConfig::USER_CONFIG[:user_name]
  CREDENTIALS[:password]  = FreeCycleConfig::USER_CONFIG[:password]

  Mail.defaults { retriever_method :imap, CREDENTIALS }

# Now we are ready to retrieve mail and work with them.

  def FreeCycleMail.search_for_location (subject)
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

      #FIXME: the location specifier is really most useful for the
      #geocoding and this may not be the best place to put it.
      unless LOCATION_SPECIFIER
        location += ", #{LOCATION_SPECIFIER}"
      end
    end
    return location
    # FIXME: it may be a good idea to remove "PDX" from the location
    # string to prevent it matching the airport.
  end

  # http://rubydoc.info/gems/mail

  def FreeCycleMail.make_email_data(email)
    data = {}
    data[:date] = email.date
    data[:message_id] = email.message_id
    data[:subject] = email.subject.sub(/^\[.*\] /, '')
    data[:location] = search_for_location(email.subject)
    data[:body] = String(email.body.match(/http:\/\/groups.yahoo.com\/group\/freecycleportland\/message\/\d+/))

  # turn email.body to a string and parse for the following:
  #  <a href="http://groups.yahoo.com/group/freecycleportland/message/239070
  #  ;_ylc=X3oDMTM5czZxaTBzBF9TAzk3MzU5NzE0BGdycElkAzExMDMyNjg2BGdycHNwSWQDMTcwNTA2NDIzNQRtc2dJZAMyMzkwNzAEc2VjA2Z0cgRzbGsDdnRwYwRzdGltZQMxMzY1MzkyNjcwBHRwY0lkAzIzOTA3MA--" style="text-decoration: none; color: #2D50FD;">Messages in this topic</a>
  # 1. substring on http://groups.yahoo.com/group/freecycleportland/message/
  #forum_link = email.body.match /http:\/\/groups.yahoo.com\/group\/freecycleportland\/message\/\d+/

    return data
  end

# We begin Heroku issues here - the error is unexpected token CRLF (expected NUMBER)
# This is a parse issue as "offers" is bringing in EVERYTHING and Heroku doesn't understand
# Possible fix could be using MailGun as an addon for Heroku to replace Imap
# Another possible fix could be that there is an error somewhere that is stopping everything
# Tried removing CRLF (see commented out below) with no luck
  def FreeCycleMail.get_recent_offers(count=nil)
    offers = Mail.find({
                         :order => :desc,
                         :what => :last,
                         :count => count,
                         :keys => ["SUBJECT", "OFFER"]
                       })
    if offers.is_a? Mail::Message
      puts look
      return [offers]
    elsif offers.is_a? Array
      # offer = offers[0].to_s
      # offer = offer.split.join("\n")
      # offer_stripped = [offer.gsub(/\r\n?/, "\n")]
      # # puts offer_stripped
      # puts offer_stripped
      return offers
    else
      raise "Invalid return from Mail.find."
    end
  end

  def FreeCycleMail.recent_offers (count=nil)
    # Updates database with messages with new message_ids.
    puts "outside"

    get_recent_offers(count).map do |email|
            puts "inside"
      data = make_email_data(email)

      # unless Location.where(:message_id => data[:message_id]).first
        Location.create!(:date       => data[:date],
                         :message_id => data[:message_id],
                         :subject    => data[:subject],
                         :body       => data[:body],
                         :location   => data[:location])
        puts "really inside"
      # end
    end
  end

  def FreeCycleMail.recent_offers_web_data
    # Return a json string of recent offer data
    return recent_offers().to_json
  end

end
