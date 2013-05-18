# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"

feature "i18n" do
  let(:citizen_password) { '123456789' }
  let(:citizen_email) { 'citizen-kane@example.com'}
  let(:fi_language) { "fi" }
  let(:en_language) { "en" }

  scenario "Visit home page as registered user with preferred language 'fi'" do
    citizen = create_logged_in_citizen({ password: citizen_password, email: citizen_email })
    citizen.profile.preferred_language = fi_language
    visit root_path
    page.should have_content "Profiili"
  end

  scenario "Visit home page as registered user with preferred language 'en'" do
    citizen = create_logged_in_citizen({ password: citizen_password, email: citizen_email })
    citizen.profile.preferred_language = en_language
    visit root_path
    page.should have_content "Logout"
  end

  scenario "Switch language as registered user (from en to fi)" do
    language = FactoryGirl.create(:language)
    citizen = create_logged_in_citizen({ password: citizen_password, email: citizen_email })
    citizen.profile.preferred_language = en_language
    visit edit_profile_path
    page.should have_content "Preferred language"
    select "Finnish", :from => "profile_preferred_language"
    click_button "Submit settings"
    visit root_path
    page.should have_content "Profiili"
  end

  scenario "Switch language as registered user (from fi to en)" do
    language = FactoryGirl.create(:language, name: "en", full_name: "English")
    citizen = create_logged_in_citizen({ password: citizen_password, email: citizen_email })
    citizen.profile.preferred_language = fi_language
    visit edit_profile_path
    page.should have_content "Kieli"
    select "English", :from => "profile_preferred_language"
    click_button "Tallenna asetukset"
    visit root_path
    page.should have_content "Settings"
  end
end