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
    login_as(citizen)
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

  def should_have_filled_the_following(fields={})
    fields.each do |field, value|
      find_field.should have_content(value)
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

  def should_be_disabled(elem)
    elem["disabled"].should_not be_nil
  end

  def should_be_enabled(elem)
    p elem["disabled"]
    elem["disabled"].should be_nil
  end

  def mock_facebook_omniauth(uid = "1234567", info = {})
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = {
      :provider => 'facebook',
      :uid => '1234567',
      :info => {
        :nickname => 'jbloggs',
        :email => 'joe@bloggs.com',
        :name => 'Joe Bloggs',
        :first_name => 'Joe',
        :last_name => 'Bloggs',
        :image => 'http://graph.facebook.com/1234567/picture?type=square',
        :urls => { :Facebook => 'http://www.facebook.com/jbloggs' },
        :location => 'Palo Alto, California',
        :verified => true
      }.merge!(info),
      :credentials => {
        :token => 'ABCDEFABCDEFABCDEFABCDEFABCDEF', # OAuth 2.0 access_token, which you may wish to store
        :expires_at => 1321747205, # when the access token expires (it always will)
        :expires => true # this will always be true
      },
      :extra => {
        :raw_info => {
          :id => uid,
          :name => 'Joe Bloggs',
          :first_name => 'Joe',
          :last_name => 'Bloggs',
          :link => 'http://www.facebook.com/jbloggs',
          :username => 'jbloggs',
          :location => { :id => '123456789', :name => 'Palo Alto, California' },
          :gender => 'male',
          :email => 'joe@bloggs.com',
          :timezone => -8,
          :locale => 'en_US',
          :verified => true,
          :updated_time => '2011-11-11T06:21:03+0000'
        }.merge!(info)
      }
    }
  end

  def create_idea(extra_attributes = {})
    Factory(:idea, extra_attributes)
  end


end

RSpec.configuration.include HelperMethods, :type => :acceptance