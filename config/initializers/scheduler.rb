require 'rufus-scheduler'
require 'pry'
load 'app/helpers/schedule_recrawl.rb'
load 'app/index/index_data.rb'

include ScheduleRecrawl

s = Rufus::Scheduler.singleton

# Check which terms need to be recrawled
s.every '1m' do
  check_recrawl
end
