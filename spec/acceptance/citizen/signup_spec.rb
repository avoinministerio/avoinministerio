# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"

feature "Citizen Signup" do

  let(:password) { '123456789' }
  let(:citizen) { Factory(:citizen, :password => '123456789', :password_confirmation => '123456789') }

  scenario "Signup" do
    visit signup_page
    fill_in "Sähköposti", :with => "citizen-kane@example.com"
    fill_in "Salasana", :with => "salainensana12345"
    fill_in "Salasanan vahvistus", :with => "salainensana12345"
    fill_in "Kutsumanimi", :with => "Cit-Kane"
    fill_in "Etunimet", :with => "Kane City"
    fill_in "Sukunimi", :with => "Citizen"
    click_button "Rekisteröidy"

    should_be_on homepage
    should_have_the_following 'Kirjaudu ulos'
  end

end