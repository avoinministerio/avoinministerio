# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"

feature "Existing citizen logins in with Facebook" do
  background do
    _citizen = Factory(:facebookin_erkki)
    mock_facebook_omniauth(_citizen.authentication.uid, email: _citizen.email)
  end

  scenario "Login with valid credentials" do
    visit homepage
    click_link "Kirjaudu Facebookilla"
    should_be_on homepage
    should_have_the_following 'Kirjaudu ulos'
  end
end