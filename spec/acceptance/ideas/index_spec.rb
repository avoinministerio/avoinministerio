# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"

feature "Ideas#index" do
  let(:citizen_password) { '123456789' }
  let(:citizen_email) { 'citizen-kane@example.com'}

  scenario "Switching between order, should change the link" do
    citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
    visit ideas_path
    page.should have_content "Uusimmat ideat"
    click_link "Uusimmat ideat"
    page.should have_content "Vanhimmat ideat"
  end
end