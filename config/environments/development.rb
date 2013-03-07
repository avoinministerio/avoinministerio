AvoinMinisterio::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Rails secret token for development environment
  config.secret_token = '6425e157ad45a7585847f91cd58634d6630cb82a60cdfdfa4c9f20a3292aaebc2f1650f8f480cd48b7a626fb02b0c2a35b9d5fde4d17e6c3b844b4fd5bf00ea6'

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false
  
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {:address => "localhost", :port => 1025}

  config.action_mailer.perform_deliveries = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = true

  # Expands the lines which load the assets
  config.assets.debug = false
  
  #config.action_mailer.default_url_options = { host: "rails.fi:3000" }

  # Signature application secret
  config.signature_secret = ENV['SIGNATURE_SECRET'] || "abc123"   # FIXME: for some reason this does not work for me in development
  p ENV
  p config.signature_secret
end
