# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# Learn more: http://github.com/javan/whenever
# Many shortcuts available: :hour, :day, :month, :year, :reboot

ROOT = File.dirname(__FILE__) + '/..'

set :output, {:standard => "#{ROOT}/log/cron.log"}
set :environment, 'production'

case @environment
  when 'production'
    every :monday, :at => '4am', :roles => [:app] do
      rake "kansalaisaloite:fetch_index", :environment => 'production',
           :output => {:standard => "#{ROOT}/log/kansalaisaloite_fetch.log"}
    end
  when 'development'
    every 2.minutes do
      rake "kansalaisaloite:fetch_index", :environment => 'development',
                 :output => {:standard => "#{ROOT}/log/kansalaisaloite_fetch.log"}
    end
end
