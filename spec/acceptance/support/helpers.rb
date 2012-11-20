# encoding: utf-8

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
    elem["disabled"].should be_nil
  end
  
  def should_have_date(locator, date)
    page.should have_select(locator + "_3i", selected: date.day.to_s)
    page.should have_select(locator + "_2i", selected: I18n.l(date, format: "%B"))
    page.should have_select(locator + "_1i", selected: date.year.to_s)
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

  # This should be refactored somewhere away
  def mac(string)
    Digest::SHA256.new.update(string).hexdigest.upcase
  end

  def calculate_mac(return_parameters, secret)
    values_string     = return_parameters.gsub(/&.+?=/, "&").gsub(/^.+?=/, "")    # just values
    values_string     = values_string.gsub(/\+/, " ")                             # convert '+'' -> space
    string = %Q!#{values_string}&#{secret}&!
    test_mac = mac(string)
    test_mac
  end

  def capybara_test_return_url(signature_id)
    service = "Capybaratesti"
    secret  = "capybaratesti"
    ENV["SECRET_#{service}"] = secret
    return_parameters = "B02K_VERS=0002&B02K_TIMESTMP=60020120708234854000001&B02K_IDNBR=0000004351&B02K_STAMP=2012070823484613889&B02K_CUSTNAME=DEMO+ANNA&B02K_KEYVERS=0001&B02K_ALG=03&B02K_CUSTID=010170-960F&B02K_CUSTTYPE=08"
    test_mac = calculate_mac(return_parameters, secret)
    "/signatures/#{signature_id}/returning/#{service}?#{return_parameters}&B02K_MAC=#{test_mac}"
  end

  # while sending POST requests with Capybara is possible,
  # it's strongly not recommended
  def visit_signature_idea_approval_path(id)
    visit signature_idea_introduction(id)
    click_button "Siirry hyväksymään ehdot"
  end
  
  def visit_signature_idea_path(id)
    visit_signature_idea_approval_path(id)
    check "accept_general"
    check "accept_non_eu_server"
    choose "publicity_Normal"
    click_button "Hyväksy ehdot ja siirry tunnistautumaan"
  end
  
  def visit_signature_returning(idea_id, citizen_id)
    visit_signature_idea_path(idea_id)
    # the signature didn't exist before this method was called,
    # therefore it can't be passed as a parameter
    signature = Signature.where(:idea_id => idea_id, :citizen_id => citizen_id).last
    visit(capybara_test_return_url(signature.id))
  end
  
  def visit_signature_finalize_signing(idea_id, citizen_id)
    visit_signature_returning(idea_id, citizen_id)
    select "Helsinki", from: "signature_occupancy_county"
    check "Vow"
    click_button "Allekirjoita"
  end
  
  def visit_signature_finalize_signing_after_shortcut_fillin(idea_id)
    visit signature_idea_shortcut_fillin_path(idea_id)
    check "Vow"
    click_button "Allekirjoita"
  end
  
  # simulates an attack
  def visit_signature_finalize_signing_directly(signature_id, idea_title, profile)
    page.driver.put("/signatures/#{signature_id}/finalize_signing",
                    {:signature => {
                      :idea_title => idea_title,
                      :idea_date => today_date,
                      :signing_date => today_date,
                      :birth_date => Date.new(1970,1,1),
                      :firstnames => profile.first_names,
                      :lastname => profile.last_name,
                      :occupancy_county => "Helsinki",
                      :vow => 1
                    }})
  end
  
  def visit_signature_shortcut_finalize_signing_directly(signature_id, idea_title, profile)
    page.driver.put(signature_shortcut_finalize_signing_path(signature_id),
                    {:params => {
                      :signature => {
                       :accept_general => 1,
                       :accept_science => 1,
                       :accept_non_eu_server => 1,
                       :accept_publicity => "Normal",
                       :idea_title => idea_title,
                       :idea_date => today_date,
                       :signing_date => today_date,
                       :birth_date => Date.new(1970,1,1),
                       :firstnames => profile.first_names,
                       :lastname => profile.last_name,
                       :occupancy_county => "Helsinki",
                       :vow => 1
                     }}})
  end

end

RSpec.configuration.include HelperMethods, :type => :acceptance