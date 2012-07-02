# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"

feature "Citizen Login" do
  let(:citizen_password) { '123456789' }
  let(:citizen_email) { 'citizen-kane@example.com'}

  background do
    create_citizen({ :password => citizen_password, :email => citizen_email })
    visit login_page
  end

  scenario "Login with valid credentials" do
    fill_in "Sähköposti", :with => citizen_email
    fill_in "Salasana", :with => citizen_password

    click_button "Kirjaudu"
    should_be_on homepage
    should_have_the_following 'Kirjaudu ulos'
  end

  scenario "Login with invalid password" do
    fill_in "Sähköposti", :with => citizen_email
    fill_in "Salasana", :with => 'invalid-password'
    click_button "Kirjaudu"

    should_be_on login_page
  end

  scenario "Login with invalid email" do
    fill_in "Sähköposti", :with => 'i-am-not-citizen-kane@emaxmple.com'
    fill_in "Salasana", :with => citizen_password
    click_button "Kirjaudu"

    should_be_on login_page
  end

end