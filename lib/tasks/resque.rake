require 'resque/tasks'

namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do
  end
end
