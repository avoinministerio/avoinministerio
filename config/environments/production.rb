AvoinMinisterio::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Rails secret token from environment variable
  config.secret_token = File.read(File.join(Rails.root, "secret_token")) rescue ENV['RAILS_SECRET_TOKEN']

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Do fallback to assets pipeline if a precompiled asset is missed
  # Surveyor requires this, hopefully nothing else gets slow
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true if ENV['FORCE_SSL']

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  config.assets.precompile += %w( vote-flow/impact-code.js admin/admin.css )

  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=315360"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  ActionMailer::Base.smtp_settings = {
    :port           => 587,
    :address        => 'smtp.mailgun.org',
    :user_name      => 'postmaster@avoinministerio.mailgun.org',
    :password       => ENV['MAILGUN_SMTP_PASSWORD'],
    :domain         => 'avoinministerio.mailgun.org',
    :authentication => :plain,
  }
  ActionMailer::Base.delivery_method = :smtp

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { host: "avoinministerio.fi"  }

  config.middleware.insert_after(::Rack::Lock, "::Rack::Auth::Basic", "Avoin ministerio") do |u, p|
    [u, p] == [ENV['AM_AUTH_USERNAME'], ENV['AM_AUTH_PASSWORD']]
  end if ENV['AM_AUTH_PASSWORD']

  # Signature application secret
  config.signature_secret = ENV['SIGNATURE_SECRET']
end
