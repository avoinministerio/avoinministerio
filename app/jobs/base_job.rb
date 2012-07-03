class BaseJob
  extend Resque::Plugins::HerokuAutoscaler
  @queue = :default
end