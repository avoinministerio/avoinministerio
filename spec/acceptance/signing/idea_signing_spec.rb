# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"
require 'webmock/rspec'

#Capybara.javascript_driver = :webkit

feature "Idea signing" do
  let(:citizen_password) { '123456789' }
  let(:citizen_email) { 'citizen-kane@example.com'}
  let(:idea) {
    Factory :idea, state: "proposal", 
                  collecting_in_service: true,
                  collecting_started: true, collecting_ended: false, 
                  collecting_start_date: today_date, collecting_end_date: today_date + 180, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:another_idea) {
    Factory :idea, state: "proposal", 
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

    # this doesn't work before javascript gets activated, and 
    # at the moment if one activates javascript there are loads of problems in other tests
    # should_be_enabled(find_button("accept"))
    click_button "Hyväksy ehdot ja siirry tunnistautumaan"

    # 4: Select TUPAS service
    # this doesn't work as WebMock.stubbing doesn't get activated. It seems the whole form gets converted into local
    # click_button "Alandsbanken testi"

    # 5: Successful returning from TUPAS, let's fill in the remaining information
    # here we're making a mock out of real TUPAS service. Instead we return with almost static, once valid url
    # just inject in the right signature.id
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

    # this doesn't work before javascript gets activated, and 
    # at the moment if one activates javascript there are loads of problems in other tests
    #should_be_enabled(find_button("Allekirjoita"))
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

    # this doesn't work before javascript gets activated, and 
    # at the moment if one activates javascript there are loads of problems in other tests
    #should_be_enabled(find_button("Allekirjoita"))
    click_button "Allekirjoita"

    # 9: Thank you page again
    page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
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
      
      scenario "4) select TUPAS service" do
        Capybara.current_driver = :mechanize
        # swithing the driver invalidates the session,
        # so we have to log in again
        create_logged_in_citizen
        visit_signature_idea_path(idea.id)
        Capybara.app_host = "https://online.alandsbanken.fi/"
        click_button "Alandsbanken testi"
        should_be_on "https://online.alandsbanken.fi/ebank/auth/initLogin.do"
        
        Capybara.current_driver = Capybara.default_driver
        Capybara.app_host = Capybara.default_host
      end
      
      scenario "5) return from TUPAS" do
        visit_signature_returning(idea.id, @citizen.id)
        signature = Signature.where(:idea_id => idea.id,
                                    :citizen_id => @citizen.id).first
        
        page.should have_field("signature_idea_title", with: idea.title)
        should_have_date("signature_idea_date", today_date)
        should_have_date("signature_signing_date", today_date)
        should_have_date("signature_birth_date", Date.new(1970,1,1))
        page.should have_field("signature_firstnames",
                               with: @citizen.first_names)
        page.should have_field("signature_lastname",
                               with: @citizen.last_name)
        page.should have_select("signature_occupancy_county", selected: nil)
        page.should have_unchecked_field("signature_vow")
        should_be_disabled(find_button("Allekirjoita"))
        
        select "Helsinki", from: "signature_occupancy_county"
        check "Vow"
        click_button "Allekirjoita"
        
        should_be_on "/signatures/#{signature.id}/finalize_signing"
      end
      
      scenario "6) thank you page" do
        visit_signature_finalize_signing(idea.id, @citizen.id)
        page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
      end
      
      scenario "7) go to the shortcut fillin page" do
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit idea_page(another_idea.id)
        click_link "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista"
        should_be_on signature_idea_shortcut_fillin_path(another_idea.id)
      end
      
      scenario "8) fill in signature" do
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit signature_idea_shortcut_fillin_path(another_idea.id)
        signature = Signature.where(:idea_id => another_idea.id,
                                    :citizen_id => @citizen.id).first
        
        page.should have_checked_field "signature_accept_general"
        page.should have_checked_field "signature_accept_non_eu_server"
        page.should have_checked_field "signature_accept_publicity_normal"
        page.should have_field("signature_idea_title", with: another_idea.title)
        should_have_date("signature_idea_date", today_date)
        should_have_date("signature_signing_date", today_date)
        should_have_date("signature_birth_date", Date.new(1970,1,1))
        page.should have_field("signature_firstnames",
                               with: @citizen.first_names)
        page.should have_field("signature_lastname",
                               with: @citizen.last_name)
        page.should have_select("signature_occupancy_county",
                                selected: "Helsinki")
        page.should have_unchecked_field("signature_vow")
        should_be_disabled(find_button("Allekirjoita"))
        
        check "Vow"
        click_button "Allekirjoita"
        
        should_be_on "/signatures/#{signature.id}/shortcut_finalize_signing"
      end
      
      scenario "9) thank you page again" do
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit_signature_finalize_signing_after_shortcut_fillin(another_idea.id)
        page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
      end
    end
    context "abnormal situations" do
      scenario "1) not logged in" do
        logout
        visit idea_page(idea.id)
        page.should_not have_link "Allekirjoita kannatusilmoitus"
      end
      
      scenario "2) not logged in" do
        logout
        visit signature_idea_introduction(idea.id)
        should_be_on new_citizen_session_path
      end
      
      scenario "3) citizen doesn't approve terms of signing" do
        visit_signature_idea_approval_path(idea.id)
        uncheck "accept_general"
        check "accept_non_eu_server"
        choose "publicity_Normal"
        click_button "Hyväksy ehdot ja siirry tunnistautumaan"
        # FIXME: the first line is correct in a way that javascript _and_ validation should prevent progressing
        # to the next page. At the moment there is no validation so moving on is actually accepted.
        # ie. fix validation, and then fix this test by removing comment from first line, and removing second line entirely
        # current_path.should_not == signature_idea_fi_path(idea.id)
        current_path.should eq(signature_idea_fi_path(idea.id))
      end
      
      scenario "4) not logged in" do
        visit_signature_idea_approval_path(idea.id)
        logout
        check "accept_general"
        check "accept_non_eu_server"
        choose "publicity_Normal"
        click_button "Hyväksy ehdot ja siirry tunnistautumaan"
        should_be_on new_citizen_session_path
      end
      
      scenario "5) citizen cancels authentication" do
        visit_signature_idea_path(idea.id)
        signature = Signature.where(:idea_id => idea.id,
                                    :citizen_id => @citizen.id).first
        visit "/signatures/#{signature.id}/cancelling/Alandsbankentesti"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_button "Allekirjoita"
      end
      
      scenario "6) citizen doesn't give the vow" do
        visit_signature_returning(idea.id, @citizen.id)
        select "Helsinki", from: "signature_occupancy_county"
        uncheck "Vow"
        click_button "Allekirjoita"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
      end
      
      scenario "7) citizen has not authenticated" do
        visit idea_page(idea.id)
        page.should_not have_link "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista"
      end
      
      scenario "8) citizen doesn't give the vow" do
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit signature_idea_shortcut_fillin_path(another_idea.id)
        uncheck "Vow"
        click_button "Allekirjoita"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
      end
      
      scenario "9) not logged in" do
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit signature_idea_shortcut_fillin_path(another_idea.id)
        logout
        check "Vow"
        click_button "Allekirjoita"
        should_be_on new_citizen_session_path
      end
    end
  end
  
  context "situation combinations" do
    context "the idea is a proposal (can be signed)" do
      context "not authenticated" do
        context "logged in" do
          context "already attempted to sign" do
            background do
              # AFAIK, @citizen can't be passed to let,
              # therefore let can't be used
              @signature = Signature.create_with_citizen_and_idea(@citizen, idea)
            end
            scenario "existing signature has empty state" do
              @signature.state = ""
              @signature.save
              
              visit_signature_finalize_signing(idea.id, @citizen.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the initial state" do
              @signature.state = "initial"
              @signature.save
              
              visit_signature_finalize_signing(idea.id, @citizen.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the authenticated state" do
              @signature.state = "authenticated"
              @signature.save
              
              visit_signature_finalize_signing(idea.id, @citizen.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the signed state" do
              @signature.state = "signed"
              @signature.save
              
              visit_signature_idea_approval_path(idea.id)
              check "accept_general"
              check "accept_non_eu_server"
              choose "publicity_Normal"
              click_button "Hyväksy ehdot ja siirry tunnistautumaan"
              current_path.should_not == signature_idea_path(idea.id)
            end
            scenario "existing signature is at the invalid return state" do
              @signature.state = "invalid return"
              @signature.save
              
              visit_signature_finalize_signing(idea.id, @citizen.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the 'too late' state" do
              @signature.state = "too late"
              @signature.save
              
              visit_signature_finalize_signing(idea.id, @citizen.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the repeated_returning state" do
              @signature.state = "repeated_returning"
              @signature.save
              
              visit_signature_finalize_signing(idea.id, @citizen.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
          end
          scenario "not attempted to sign before" do
            visit_signature_finalize_signing(idea.id, @citizen.id)
            page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
          end
        end
        scenario "not logged in" do
          logout
          visit idea_page(idea.id)
          page.should_not have_link "Allekirjoita kannatusilmoitus"
        end
      end
    end
  end
  
  context "situation combinations" do
    context "the idea is a proposal (can be signed)" do
      context "not authenticated" do
        context "logged in" do
          context "already attempted to sign" do
            background do
              # AFAIK, @citizen can't be passed to let,
              # therefore let can't be used
              @signature = Signature.create_with_citizen_and_idea(@citizen, idea)
            end
            scenario "existing signature has empty state" do
              @signature.state = ""
              @signature.save
              
              visit_signature_finalize_signing(idea.id,
                                               @citizen.id,
                                               "Alandsbankentesti")
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the initial state" do
              @signature.state = "initial"
              @signature.save
              
              visit_signature_finalize_signing(idea.id,
                                               @citizen.id,
                                               "Alandsbankentesti")
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the authenticated state" do
              @signature.state = "authenticated"
              @signature.save
              
              visit_signature_finalize_signing(idea.id,
                                               @citizen.id,
                                               "Alandsbankentesti")
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the signed state" do
              @signature.state = "signed"
              @signature.save
              
              visit_signature_idea_approval_path(idea.id)
              check "accept_general"
              check "accept_non_eu_server"
              choose "publicity_Normal"
              click_button "Hyväksy ehdot ja siirry tunnistautumaan"
              current_path.should_not == signature_idea_path(idea.id)
            end
            scenario "existing signature is at the invalid return state" do
              @signature.state = "invalid return"
              @signature.save
              
              visit_signature_finalize_signing(idea.id,
                                               @citizen.id,
                                               "Alandsbankentesti")
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the 'too late' state" do
              @signature.state = "too late"
              @signature.save
              
              visit_signature_finalize_signing(idea.id,
                                               @citizen.id,
                                               "Alandsbankentesti")
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the repeated_returning state" do
              @signature.state = "repeated_returning"
              @signature.save
              
              visit_signature_finalize_signing(idea.id,
                                               @citizen.id,
                                               "Alandsbankentesti")
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
          end
          scenario "not attempted to sign before" do
            visit_signature_finalize_signing(idea.id,
                                               @citizen.id,
                                               "Alandsbankentesti")
            page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
          end
        end
      end
      context "authenticated" do
        background do
          visit_signature_finalize_signing(another_idea.id, @citizen.id)
        end
        context "logged in" do
          context "already attempted to sign" do
            background do
              # AFAIK, @citizen can't be passed to let,
              # therefore let can't be used
              @signature = Signature.create_with_citizen_and_idea(@citizen, idea)
            end
            scenario "existing signature has empty state" do
              @signature.state = ""
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the initial state" do
              @signature.state = "initial"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the authenticated state" do
              @signature.state = "authenticated"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the signed state" do
              @signature.state = "signed"
              @signature.save
              
              visit signature_idea_shortcut_fillin_path(idea.id)
              page.should have_content "Aiemmin allekirjoitettu"
              page.should_not have_button "Allekirjoita"
            end
            scenario "existing signature is at the invalid return state" do
              @signature.state = "invalid return"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the 'too late' state" do
              @signature.state = "too late"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the repeated_returning state" do
              @signature.state = "repeated_returning"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
          end
          scenario "not attempted to sign before" do
            visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
            page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
          end
        end
        scenario "not logged in" do
          logout
          visit signature_idea_shortcut_fillin_path(idea.id)
          should_be_on new_citizen_session_path
        end
      end
    end
  end

end