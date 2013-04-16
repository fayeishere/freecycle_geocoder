#!/usr/bin/env ruby

require 'optparse'
require './freecycle_mail'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: get_mail.orb [options]"

  opts.on("-n" "--number", "get number of mails") do |n|
    options[:number] = n
  end
  
end.parse!



FreeCycleMail.recent_offers(options[:number]).each do |offer|
  Location.create(offer)
end
