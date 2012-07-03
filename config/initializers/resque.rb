ENV["REDISTOGO_URL"] ||= "redis://redistogo:@localhost:6379/1"

uri = URI.parse(ENV["REDISTOGO_URL"])
uri = URI.parse(ENV["REDISTOGO_URL"])
redis_connection_attrs = { host: uri.host, port: uri.port }
redis_connection_attrs.merge!(password: uri.password) if uri.password.present?
::Redis.new(redis_connection_attrs)

# REVIEW: For testing - jaakko
Resque.inline = ((Rails.env =~ /development|test/) == 0)

# REVIEW: https://github.com/ajmurmann/resque-heroku-autoscaler
Resque::Plugins::HerokuAutoscaler.config do |_config|
  _config.scaling_disabled = ((Rails.env =~ /development|test/) == 0)

  _config.heroku_user = ENV['HEROKU_USERNAME']
  _config.heroku_pass = ENV['HEROKU_PASSWORD']
  _config.heroku_app  = ENV['HEROKU_APP']
  _config.new_worker_count do |pending|
    ( pending / 5 ).ceil.to_i
  end
end

# REVIEW: Setup async mailer as defaul mailer - https://github.com/zapnap/resque_mailer
class AsyncMailer < ActionMailer::Base
  include Resque::Mailer
end

Resque::Mailer.excluded_environments = [:test, :development]