# encoding: UTF-8
require 'acceptancejs/acceptancejs_helper'
feature "Idea signing" do
  let(:citizen_password) { '123456789' }
  let(:citizen_email) { 'citizen-kane@example.com'}
  let(:idea) {
    FactoryGirl.create :idea, state: "proposal", 
    collecting_in_service: true,
    collecting_started: true, collecting_ended: false, 
    collecting_start_date: today_date, collecting_end_date: today_date + 180, 
    additional_signatures_count: 0, additional_signatures_count_date: today_date, 
    target_count: 51500
  }
  let(:another_idea) {
    FactoryGirl.create :idea, state: "proposal", 
    collecting_in_service: true,
    collecting_started: true, collecting_ended: false, 
    collecting_start_date: today_date, collecting_end_date: today_date + 180, 
    additional_signatures_count: 0, additional_signatures_count_date: today_date, 
    target_count: 51500
  }

  def logged_in_citizen_on_homepage
    case 2
    when 1
      @citizen = create_citizen({ :password => citizen_password, :email => citizen_email })
      visit login_page
      fill_in "Sähköposti", :with => citizen_email
      fill_in "Salasana", :with => citizen_password
      click_button "Kirjaudu"
    when 2
      @citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit homepage
    end
  end

  background do
    logged_in_citizen_on_homepage
    should_be_on homepage
  end

  scenario "Succesful normal idea signing", js: true do #, :driver => :webkit do
    # 1: Create idea and visit it's page to click on signing
    visit idea_page(idea.id)
    should_be_on idea_page(idea.id)
    # click_link "Allekirjoita kannatusilmoitus"
    click_link "Jätä kannatusilmoitus"
    should_be_on signature_idea_introduction(idea.id)

    # 2: Click forward
    # click_button "Siirry hyväksymään ehdot"
    click_button "Eteenpäin"
    should_be_disabled(find_button("accept"))

    # 3: Fill in defaults
    check "accept_general"
    should_be_disabled(find_button("accept"))
    check "accept_science"
    should_be_disabled(find_button("accept"))
    # check "accept_non_eu_server"
    should_be_disabled(find_button("accept"))
    choose("publicity_Immediately")

    # this doesn't work before javascript gets activated, and at the moment if
    # one activates javascript there are loads of problems in other tests
    # should_be_enabled(find_button("accept"))

    #click_button "Hyväksy ehdot ja siirry tunnistautumaan"
    click_button "Eteenpäin"

    # 4: Select TUPAS service this doesn't work as WebMock.stubbing doesn't get
    # activated. It seems the whole form gets converted into local
    check "accept_general"
    # check "accept_non_eu_server"
    check "accept_science"
    choose("publicity_Normal")
    click_button "Eteenpäin"

    # 5: Successful returning from TUPAS, let's fill in the remaining
    # information here we're making a mock out of real TUPAS service. Instead we
    # return with almost static, once valid url just inject in the right
    # signature.id
    signature = Signature.all.last
    # the url has a fake MAC, calculated with secret set up here
    visit(capybara_test_return_url(signature.id))
    signature = Signature.all.last # requires reloading after visit, as controller updates for example date

    page.should have_field('signature_idea_title', with: "Idea uudesta laista")
    page.should have_select('signature_idea_date_3i',     selected: idea.updated_at.day.to_s)
    page.should have_select('signature_idea_date_2i',     selected: I18n.l(idea.updated_at, format: "%B"))
    page.should have_select('signature_idea_date_1i',     selected: idea.updated_at.year.to_s)
    page.should have_select('signature_signing_date_3i',  selected: signature.signing_date.day.to_s)
    page.should have_select('signature_signing_date_2i',  selected: I18n.l(signature.signing_date, format: "%B"))
    page.should have_select('signature_signing_date_1i',  selected: signature.signing_date.year.to_s)
    page.should have_select('signature_birth_date_3i',    selected: "1")
    page.should have_select('signature_birth_date_2i',    selected: "tammikuu")  # manually translated
    page.should have_select('signature_birth_date_1i',    selected: "1970")
    page.should have_field('signature_firstnames',        with:     "Erkki Kalevi")
    page.should have_select('signature_occupancy_county', selected: nil)
    page.should have_unchecked_field('signature_vow')
    should_be_disabled(find_button("Allekirjoita"))

    select "Helsinki", from: "signature_occupancy_county"
    check "Vow"

    # this doesn't work before javascript gets activated, and at the moment if
    # one activates javascript there are loads of problems in other tests
    should_be_enabled(find_button("Allekirjoita"))
    click_button "Allekirjoita"

    # 6: Thank you page
    page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"

    # 7: Let's check the session works
    visit idea_page(another_idea.id)
    page.should have_link "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista"
    click_link "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista"

    # 8: Let's check both forms and add only vows
    page.should have_checked_field('signature_accept_general')
    page.should have_checked_field('signature_accept_science')
    page.should have_checked_field('signature_accept_non_eu_server')
    page.should have_checked_field('signature_accept_publicity_immediately')

    page.should have_field('signature_idea_title', with: "Idea uudesta laista")
    page.should have_select('signature_idea_date_3i',     selected: idea.updated_at.day.to_s)
    page.should have_select('signature_idea_date_2i',     selected: I18n.l(idea.updated_at, format: "%B"))
    page.should have_select('signature_idea_date_1i',     selected: idea.updated_at.year.to_s)
    page.should have_select('signature_signing_date_3i',  selected: signature.signing_date.day.to_s)
    page.should have_select('signature_signing_date_2i',  selected: I18n.l(signature.signing_date, format: "%B"))
    page.should have_select('signature_signing_date_1i',  selected: signature.signing_date.year.to_s)
    page.should have_select('signature_birth_date_3i',    selected: "1")
    page.should have_select('signature_birth_date_2i',    selected: "tammikuu")  # manually translated
    page.should have_select('signature_birth_date_1i',    selected: "1970")
    page.should have_field('signature_firstnames',        with:     "Erkki Kalevi")
    page.should have_select('signature_occupancy_county', selected: "Helsinki")
    page.should have_unchecked_field('signature_vow')
    should_be_disabled(find_button("Allekirjoita"))

    check "Vow"

    # this doesn't work before javascript gets activated, and at the moment if
    # one activates javascript there are loads of problems in other tests
    # #should_be_enabled(find_button("Allekirjoita"))
    click_button "Allekirjoita"

    # 9: Thank you page again
    page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
  end
end
