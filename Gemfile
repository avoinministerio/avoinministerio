source 'http://rubygems.org'

gem "rails", "3.1.3"

gem "pg"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.1.5"
  gem "coffee-rails", "~> 3.1.1"
  gem "uglifier",     ">= 1.0.3"
  gem "haml_coffee_assets"
  gem "execjs"
end

gem "jquery-rails"
gem "rails-backbone"
gem "haml-rails"

gem "devise"
gem "simple_form"
gem "state_machine"

gem "rspec-rails", group: [ :development, :test ]

group :test do
  gem "spork", "> 0.9.0.rc"
  gem 'rb-fsevent', require: false if RUBY_PLATFORM =~ /darwin/i
  gem "capybara"
  gem "factory_girl_rails", "1.4.0", require: false
  gem "shoulda-matchers"
  gem "database_cleaner"
  gem "turn", "~> 0.8.3", require: false
end
