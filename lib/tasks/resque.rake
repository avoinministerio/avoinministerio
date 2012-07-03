require 'resque/tasks'

task "resque:setup" => :environment do
  ENV['QUEUE'] = '*'
  Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection }
end