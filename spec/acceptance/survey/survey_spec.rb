#encoding: utf-8

require "acceptance/acceptance_helper"

feature "Survey" do

  scenario "User should be to go to survey from sign_up page" do
    visit(new_citizen_registration_path)
    click_on 'Voit ottaa kyselyyn'
    page.should have_css('#surveyor')

  end

end
