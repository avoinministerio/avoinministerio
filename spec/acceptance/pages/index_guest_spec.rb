# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"

feature "i18n" do
  scenario "Visit home page as guest and switch between languages" do
    visit root_path
    page.should have_content "Kirjaudu"
    click_link "Greatbritain"
    page.should have_content "Login"
    click_link "Finland"
    page.should have_content "Kirjaudu"
  end
end