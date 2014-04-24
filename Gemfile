source "https://rubygems.org"

gem "rails", "3.2.17"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "coffee-rails", "~> 3.2.2"
  gem "sass-rails",   "= 3.2.5"
  gem "uglifier",     ">= 1.3.0"
end

gem "devise", '2.1.2'
gem "factory_girl_rails", "4.1.0", :require => false
gem "friendly_id"
gem "gravatar-ultimate"
gem "geocoder"
gem "haml-rails"
gem "i18n_routing"
gem "jquery-rails"
gem 'jquery-ui-rails'
gem "nokogiri"
gem "omniauth-facebook"
gem "rails-i18n"
gem "rails-translate-routes"
gem "rake", ">= 0.9.2"
gem "redcarpet"
gem "simple_form"
gem "state_machine"
gem "will_paginate", "~> 3.0"
gem "differ"
gem "hominid"
gem 'mailboxer'
#gem "indextank"
gem "tanker", :git => "git://github.com/kidpollo/tanker.git"
gem "unicorn"
gem "surveyor", "~> 1.1.0"

gem "rspec-rails", :groups => [ :development, :test ]
gem "impressionist", "~> 1.2.0"

group :development do
  gem "rails-erd"
  gem "sqlite3"
  gem "unicorn"
  gem "guard", "1.0.3"
  gem "guard-rspec", "0.7.3"
  gem "guard-spork", "1.0.0"
  gem "brakeman", "~> 1.6.2"
  gem "pry-rails"
  gem "launchy"
  gem "debugger"
end

group :production do
  gem "newrelic_rpm", "~> 3.5.7.59"
  gem "pg"
end

group :test do
  gem "spork-rails"
  gem "capybara"
  gem "database_cleaner"
  gem "rspec-rails-controller"
  gem "shoulda-matchers"
  gem "simplecov", :require => false
  gem "turn", "~> 0.8.3", :require => false
  gem "webmock", :require => false
  gem "email_spec"
  gem "steak"
  gem "mime-types"
  gem "capybara-mechanize"
  gem "timecop"
  gem "sqlite3"

  if ENV["DB"] == "postgres"
    gem "pg"
  end
end

group :profile do
  # gem 'ruby-prof'
end

group :mac_test do
  gem "rb-fsevent", :require => false
end

group :linux_test do
  gem "therubyracer", :require => false
  gem "libnotify", :require => false
end
