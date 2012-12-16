require 'thread'

module Rack
  class Lock
    FLAG = 'rack.multithread'.freeze

    def initialize(app, mutex = Mutex.new)
      @app, @mutex = app, mutex
    end

    def call(env)
      old, env[FLAG] = env[FLAG], false

      # Capture the mutex for the closure below
      mutex = @mutex
      mutex.lock
      response     = @app.call(env)
      body         = response[2]
      should_super = body.respond_to?(:close)

      body.extend Module.new {
        define_method(:close) do
          begin
            super() if should_super
          ensure
            mutex.unlock
          end
        end
      }
      response
    ensure
      env[FLAG] = old
    end
  end
end