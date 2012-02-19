source 'http://rubygems.org'

gem "rails", "3.1.3"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.1.5"
  gem "coffee-rails", "~> 3.1.1"
  gem "uglifier",     ">= 1.0.3"
end

gem "devise"
gem "haml-rails"
gem "i18n_routing"
gem "jquery-rails"
gem "rails-i18n"
gem "redcarpet"
gem "simple_form"
gem "state_machine"
gem "omniauth-facebook"

gem "rspec-rails", group: [ :development, :test ]

group :development do
  gem "sqlite3"
  gem "rails-erd"
  gem "thin"
end

group :production do
  gem "pg"
  gem 'thin'
end

group :test do
  gem "spork", "> 0.9.0.rc"
  gem 'rb-fsevent'#, require: false if RUBY_PLATFORM =~ /darwin/i
  gem "capybara"
  gem "factory_girl_rails", "1.4.0", require: false
  gem "shoulda-matchers"
  gem "database_cleaner"
  gem "turn", "~> 0.8.3", require: false
end
