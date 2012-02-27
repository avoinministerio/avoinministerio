source 'http://rubygems.org'

gem "rails", "3.1.3"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "coffee-rails", "~> 3.1.1"
  gem "sass-rails",   "~> 3.1.5"
  gem "uglifier",     ">= 1.0.3"
end

gem "devise"
gem "haml-rails"
gem "i18n_routing"
gem "jquery-rails"
gem "omniauth-facebook"
gem "rails-i18n"
gem "rake", ">= 0.9.2"
gem "redcarpet"
gem "simple_form"
gem "state_machine"

gem "rspec-rails", :groups => [ :development, :test ]

group :development do
  gem "rails-erd"
  gem "sqlite3"
  gem "thin"
end

group :production do
  gem "newrelic_rpm"
  gem "pg"
  gem 'thin'
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "factory_girl_rails", "1.4.0", :require => false
  gem "shoulda-matchers"
  gem "spork", "> 0.9.0.rc"
  gem "turn", "~> 0.8.3", :require => false
end

group :mac_test do
  gem "rb-fsevent", :require => false
end
