# REVIEW: https://github.com/plataformatec/devise/wiki/How-To:-Controllers-and-Views-tests-with-Rails-3-(and-rspec) - jaakkos
# REVIEW: https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara - jaakkos

require 'uri'

include Warden::Test::Helpers
Warden.test_mode!

module HelperMethods
  # Put helper methods you need to be available in all acceptance specs here.
  def create_citizen(extra_attributes = {})
    Factory(:citizen, extra_attributes)
  end

  def create_logged_in_citizen(extra_attributes = {})
    citizen = create_citizen(extra_attributes)
    login(citizen)
    citizen
  end

  def login_as_citizen(citizen)
    login_as(citizen, :scope => :citizen)
  end

  def create_logged_in_administrator
    administrator = Factory(:administrator)
    login_as_administrator(administrator)
    administrator
  end

  def login_as_administrator(administrator)
    login_as(administrator, :scope => :administrator)
  end

  def should_have_errors(*messages)
    within(:css, "#error") do
      messages.each { |msg| page.should have_content(msg) }
    end
  end
  alias_method :should_have_error, :should_have_errors

  def fill_the_following(fields={})
    fields.each do |field, value|
      fill_in field,  :with => value
    end
  end

  def should_have_the_following(*contents)
    contents.each do |content|
      page.should have_content(content)
    end
  end

  def should_have_table(table_name, *rows)
    within(table_name) do
      rows.each do |columns|
        columns.each { |content| page.should have_content(content) }
      end
    end
  end

  def should_be_on(url)
    unless (url =~ URI::regexp).nil?
      current_url.should == url
    else
      current_path.should == url
    end
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance