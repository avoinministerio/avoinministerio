# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"
require 'webmock/rspec'

#Capybara.javascript_driver = :webkit


feature "Idea signing" do
  let(:citizen_password) { '123456789' }
  let(:citizen_email) { 'citizen-kane@example.com'}
  let(:idea) {
    Factory :idea, state: "proposal", 
                  collecting_started: true, collecting_ended: false, 
                  collecting_start_date: today_date, collecting_end_date: today_date + 180, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }

  background do
    case 2
    when 1
      create_citizen({ :password => citizen_password, :email => citizen_email })
      visit login_page
      fill_in "Sähköposti", :with => citizen_email
      fill_in "Salasana", :with => citizen_password
      click_button "Kirjaudu"
    when 2
      create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
#      stub_request(:get, /http:\/\/127.0.0.1:\d+\/__identify__/).
#               with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
#               to_return(:status => 200, :body => "", :headers => {})
#      stub_request(:get, "http://127.0.0.1:63472/__identify__").
#               with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'})
#      stub_request(:any, "/4na.api.searchify.com/")
      visit homepage
    end

    should_be_on homepage
  end

  scenario "Succesful normal idea signing" do #, js: true do #, :driver => :webkit do
    # 1: Create idea and visit it's page to click on signing
    visit idea_page(idea.id)
    should_be_on idea_page(idea.id)
    click_link "Allekirjoita kannatusilmoitus"
    should_be_on signature_idea_introduction(idea.id)

    # 2: Click forward
    click_button "Siirry hyväksymään ehdot"
    should_be_disabled(find_button("accept"))

    # 3: Fill in defaults
    check "accept_general"
    should_be_disabled(find_button("accept"))
    check "accept_science"
    should_be_disabled(find_button("accept"))
    check "accept_non_eu_server"
    should_be_disabled(find_button("accept"))
    choose("publicity_Immediately")
    # save_and_open_page

    # this doesn't work before javascript gets activated, and 
    # at the moment if one activates javascript there are loads of problems in other tests
    # should_be_enabled(find_button("accept"))
    click_button "Hyväksy ehdot ja siirry tunnistautumaan"
    # save_and_open_page

    # 4: Select TUPAS service
    # this doesn't work as WebMock.stubbing doesn't get activated. It seems the whole form gets converted into local
    # click_button "Alandsbanken testi"

    # 5: Successful returning from TUPAS, let's fill in the remaining information
    # here we're making a mock out of real TUPAS service. Instead we return with almost static, once valid url
    # just inject in the right signature.id
    visit("/signatures/#{Signature.all.last.id}/returning/Alandsbankentesti?B02K_VERS=0002&B02K_TIMESTMP=60020120708234854000001&B02K_IDNBR=0000004351&B02K_STAMP=2012070823484613889&B02K_CUSTNAME=DEMO+ANNA&B02K_KEYVERS=0001&B02K_ALG=03&B02K_CUSTID=010170-960F&B02K_CUSTTYPE=08&B02K_MAC=31342513E20EB7374AAF867A91EA4FAB990B519E02C641C1376D7396D969AE3F")

    has_field?('signature_idea_title', with: "Idea uudesta laista")
    has_select?('signature_idea_date_3i', selected: "8")
    has_select?('signature_idea_date_2i', selected: "7")
    has_select?('signature_idea_date_1i', selected: "2012")
    has_select?('signature_signing_date_3i', selected: "9")
    has_select?('signature_signing_date_2i', selected: "7")
    has_select?('signature_signing_date_1i', selected: "2012")
    has_select?('signature_birth_date_3i', selected: "1")
    has_select?('signature_birth_date_2i', selected: "1")
    has_select?('signature_birth_date_1i', selected: "1970")
    has_field?('signature_firstnames', with: "Erkki Kalevi")
    has_select?('signature_occupancy_county', selected: nil)
    has_unchecked_field?('signature_vow')
    should_be_disabled(find_button("Allekirjoita"))

    select "Helsinki", from: "signature_occupancy_county"
    check "Vow"
    # save_and_open_page

    # this doesn't work before javascript gets activated, and 
    # at the moment if one activates javascript there are loads of problems in other tests
    #should_be_enabled(find_button("Allekirjoita"))
    click_button "Allekirjoita"

    # 6: Thank you page
    have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"

    # 7: Let's check the session works
    create_idea({ state: "proposal", 
                  collecting_started: true, collecting_ended: false, 
                  collecting_start_date: today_date, collecting_end_date: today_date + 180, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500 })
    visit idea_page(2)
    # save_and_open_page
    has_no_link? "Allekirjoita kannatusilmoitus"
    has_link? "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista"
    click_link "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista"

    # 8: Let's check both forms and add only vows
    has_checked_field?('accept_general')
    has_checked_field?('accept_science')
    has_checked_field?('accept_non_eu_server')
    has_checked_field?('publicity_Immediately')

    has_field?('signature_idea_title', with: "Idea uudesta laista")
    has_select?('signature_idea_date_3i', selected: "8")
    has_select?('signature_idea_date_2i', selected: "7")
    has_select?('signature_idea_date_1i', selected: "2012")
    has_select?('signature_signing_date_3i', selected: "9")
    has_select?('signature_signing_date_2i', selected: "7")
    has_select?('signature_signing_date_1i', selected: "2012")
    has_select?('signature_birth_date_3i', selected: "1")
    has_select?('signature_birth_date_2i', selected: "1")
    has_select?('signature_birth_date_1i', selected: "1970")
    has_field?('signature_firstnames', with: "Erkki Kalevi")
    has_select?('signature_occupancy_county', selected: "Helsinki")
    has_unchecked_field?('signature_vow')
    should_be_disabled(find_button("Allekirjoita"))

    check "Vow"
    # save_and_open_page

    # this doesn't work before javascript gets activated, and 
    # at the moment if one activates javascript there are loads of problems in other tests
    #should_be_enabled(find_button("Allekirjoita"))
    click_button "Allekirjoita"

    # 9: Thank you page again
    have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
  end
  
  context "individual steps" do
    context "normal flow" do
      scenario "1) go to the introduction page" do
        visit idea_page(idea.id)
        click_link "Allekirjoita kannatusilmoitus"
        should_be_on signature_idea_introduction(idea.id)
      end
      
      scenario "2) go to the approval page" do
        visit signature_idea_introduction(idea.id)
        click_button "Siirry hyväksymään ehdot"
        should_be_on signature_idea_approval_path(idea.id)
      end
      
      scenario "3) approve terms of signing" do
        visit_signature_idea_approval_path(idea.id)
        check "accept_general"
        check "accept_non_eu_server"
        choose "publicity_Normal"
        click_button "Hyväksy ehdot ja siirry tunnistautumaan"
        should_be_on signature_idea_path(idea.id)
      end
    end
  end

end