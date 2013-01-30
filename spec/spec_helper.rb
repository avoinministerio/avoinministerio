require "rubygems"
require "spork"

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  ENV["RAILS_ENV"] ||= "test"
  require File.expand_path("../../config/environment", __FILE__)

  require "rspec/rails"
  require "rspec/rails/controller"
  require "rspec/autorun"

  require "steak"

  require "shoulda/matchers/integrations/rspec"
  require "factory_girl_rails"

  require "database_cleaner"
  require "controller_test_helper"
  require "webmock/rspec"
  require "email_spec"

  # Capybara + Steak + Timecop for integration test
  require "capybara/rspec"
  require "steak"
  require "capybara/mechanize"
  require "timecop"

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = true
    config.include(RSpec::Rails::Controller::Macros, :type => :controller)

    # REVIEW: https://github.com/bmabey/email-spec - jaakko
    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)

    # config.infer_base_class_for_anonymous_controllers = false

    config.treat_symbols_as_metadata_keys_with_true_values = true
    # config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      WebMock.stub_request(:any, /4na.api.searchify.com/)
      WebMock.stub_request(:any, /online.alandsbanken.fi/)
    end

    config.after(:each) do
      DatabaseCleaner.clean
      Warden.test_reset!
    end
  end
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  
  # REVIEW: https://github.com/sporkrb/spork/wiki/Spork.trap_method-Jujitsu - jaakko
  # This code will be run each time you run your specs.
  FactoryGirl.reload
  I18n.backend.reload!

  # REVIEW: Using inmemory Sqlite3, we have to reload schema on each run - jaakko
  ActiveRecord::Schema.verbose = false
  load "#{Rails.root.to_s}/db/schema.rb"

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|_support_file| require _support_file}

  # Put your acceptance spec helpers inside spec/acceptance/support
  Dir[Rails.root.join("spec/acceptance/support/**/*.rb")].each {|_support_file| require _support_file}
end

# REVIEW: https://github.com/sporkrb/spork/wiki/Spork.trap_method-Jujitsu Devise - jaakko
Spork.trap_method(Rails::Application::RoutesReloader, :reload!)
