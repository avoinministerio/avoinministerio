#encoding: utf-8

require "acceptance/acceptance_helper"

Capybara.javascript_driver = :webkit
feature "Survey" do

  scenario "User should be to go to survey after sign_up" do
    visit signup_page
    fill_in "Sähköposti", :with => "citizen-kane@example.com"
    fill_in "Salasana", :with => "salainensana12345"
    fill_in "Salasanan vahvistus", :with => "salainensana12345"
    fill_in "Kutsumanimi", :with => "Cit-Kane"
    fill_in "Etunimet", :with => "Kane City"
    fill_in "Sukunimi", :with => "Citizen"
    click_button "Rekisteröidy"

    should_be_on after_sign_up
    click_on "Osallistu tieteelliseen tutkimukseen -- täytä kysely"
    page.should have_content('#surveyor')
    should_be_on take_survey_path(:survey_code => SURVEY_ACCESS_CODE[:fi])
  end

end
