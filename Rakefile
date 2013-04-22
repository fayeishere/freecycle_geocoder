#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

FreecycleGeocoder::Application.load_tasks

desc 'Add recent offers to database'
task :recent_offers => :environment do
  require './lib/freecycle_mail'
  FreeCycleMail.recent_offers
end

desc 'Remove old offers from database'
task :remove_old_offers => :environment do
  Location.where(:date < Time.now - (60 * 60 * 24 * 14)).destroy_all
end
