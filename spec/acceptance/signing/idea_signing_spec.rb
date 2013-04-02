# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"
require 'webmock/rspec'

# Set to true if you want to run tests which send PUT requests
RUN_PUT_TESTS = false

# #Capybara.javascript_driver = :webkit

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

  scenario "Succesful normal idea signing", js: true do #, js: true do #, :driver => :webkit do
    # 1: Create idea and visit it's page to click on signing
    visit idea_page(idea.id)
    should_be_on idea_page(idea.id)
    click_link  "Jätä kannatusilmoitus"
    should_be_on signature_idea_introduction(idea.id)
    puts Idea.first.attributes

    # 2: Click forward
    click_button "Eteenpäin"

    page.has_button?("accept").should be_false
    # 3: Fill in defaults
    check "accept_general"
    page.has_button?("accept").should be_false
    check "accept_science"
    page.has_button?("accept").should be_false
    check "accept_non_eu_server"
    page.has_button?("accept").should be_false
    choose("publicity_Immediately")
    page.has_button?("accept").should be_true

    # this doesn't work before javascript gets activated, and at the moment if
    # one activates javascript there are loads of problems in other tests
    # should_be_enabled(find_button("accept"))
    click_button "Eteenpäin"

    # 4: Select TUPAS service this doesn't work as WebMock.stubbing doesn't get
    # activated. It seems the whole form gets converted into local
    click_button "Alandsbanken (0.28€)"

    # 5: Successful returning from TUPAS, let's fill in the remaining
    # information here we're making a mock out of real TUPAS service. Instead we
    # return with almost static, once valid url just inject in the right
    # signature.id
    signature = Signature.all.last
    # the url has a fake MAC, calculated with secret set up here
    visit(capybara_test_return_url(signature.id))
    signature = Signature.all.last # requires reloading after visit, as controller updates for example date

    have_field_with_text("signature_idea_title", idea.title)
    have_field_with_date('signature_idea_date', today_date)
    have_field_with_date('signature_signing_date', today_date)
    have_field_with_date('signature_birth_date', Date.new(1970,1,1))
    have_field_with_text("signature_firstnames", @citizen.first_names)
    have_field_with_text("signature_lastname", @citizen.last_name)
    page.has_select?("signature_occupancy_county", selected: nil)
    page.should have_unchecked_field("signature_vow")
    should_be_disabled(find(:id, "commit"))
    signature.state.should == "authenticated"
    puts Capybara.current_driver
    select "Helsinki", from: "signature_occupancy_county"
    check "Vow"
    click_on "Allekirjoita"

    should_be_on "/signatures/#{signature.id}/finalize_signing"
  end

  context "individual steps", js: true do
    context "normal flow" do
      scenario "1) go to the introduction page" do
        visit idea_page(idea.id)
        click_link "Jätä kannatusilmoitus"
        should_be_on signature_idea_introduction(idea.id)
      end

      scenario "2) go to the approval page" do
        visit signature_idea_introduction(idea.id)
        click_button "Eteenpäin"
        should_be_on signature_idea_approval_path(idea.id)
      end

      scenario "3) approve terms of signing" do
        visit_signature_idea_path(idea.id)
      end

      scenario "4) select TUPAS service" do
        visit_signature_idea_path(idea.id)
        click_button "Alandsbanken (0.28€)"
        should_be_on "https://online.alandsbanken.fi/aab/ebank/auth/initLogin.do?BV_UseBVCookie=no"
      end

      scenario "5) return from TUPAS" do
        visit_signature_returning(idea.id, @citizen.id)
        signature = Signature.where(:idea_id => idea.id,
                                    :citizen_id => @citizen.id).last
        have_field_with_text("signature_idea_title", idea.title)
        have_field_with_date('signature_idea_date', today_date)
        have_field_with_date('signature_signing_date', today_date)
        have_field_with_date('signature_birth_date', Date.new(1970,1,1))
        have_field_with_text("signature_firstnames", @citizen.first_names)
        have_field_with_text("signature_lastname", @citizen.last_name)
        page.has_select?("signature_occupancy_county", selected: nil)
        page.should have_unchecked_field("signature_vow")
        should_be_disabled(find(:id, "commit"))
        signature.state.should == "authenticated"
        puts Capybara.current_driver
        select "Helsinki", from: "signature_occupancy_county"
        check "Vow"
        click_on "Allekirjoita"
        
        should_be_on "/signatures/#{signature.id}/finalize_signing"
      end

      scenario "6) thank you page" do
        pending "have no valid auth maybe timecop should be used here"
        visit_signature_finalize_signing(idea.id, @citizen.id)
        page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
        save_and_open_page
        page.should have_content "Tunnistautumisesi on nyt voimassa" # fail
        signature = Signature.where(:idea_id => idea.id,
                                    :citizen_id => @citizen.id).last
        signature.state.should == "signed"
      end
      
      scenario "7) go to the shortcut fillin page" do
        pending "link to shortcut_fillin is never used"
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit idea_page(another_idea.id)
        click_link "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista" # fail
        should_be_on signature_idea_shortcut_fillin_path(another_idea.id)
      end
      
      scenario "8) fill in signature" do
        pending "on which page we should land after visit_signature_idea_shortcut_fillin_path"
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit signature_idea_shortcut_fillin_path(another_idea.id)
        signature = Signature.where(:idea_id => another_idea.id,
                                    :citizen_id => @citizen.id).first
        # we are not on proper page here maybe signature used in the example have no valid state for finalizing
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
        signature.state.should == "authenticated"
        
        check "Vow"
        click_button "Allekirjoita"
        
        should_be_on "/signatures/#{signature.id}/shortcut_finalize_signing"
      end
      
      scenario "9) thank you page again" do
        pending "broken helper visit_signature_finalize_signing_after_shortcut_fillin"
        # visit_signature_finalize_signing(idea.id, @citizen.id)
        # visit_signature_finalize_signing_after_shortcut_fillin(another_idea.id)
        # page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
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
        page.has_no_button? "Eteenpäin"
        check "accept_general"
        page.has_button? "Eteenpäin"
      end
      
      scenario "4) not logged in" do
        visit_signature_idea_approval_path(idea.id)
        logout
        check "accept_general"
        check "accept_non_eu_server"
        choose "publicity_Normal"
        click_button "Eteenpäin"
        should_be_on new_citizen_session_path
      end
      
      scenario "5) citizen cancels authentication" do
        visit_signature_idea_path(idea.id)
        signature = Signature.where(:idea_id => idea.id,
          :citizen_id => @citizen.id).first
        visit "/signatures/#{signature.id}/cancelling/Alandsbankentesti"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_button "Allekirjoita"
        signature.reload
        signature.state.should == "cancelled"
      end
      
      scenario "6) citizen doesn't give the vow" do
        visit_signature_returning(idea.id, @citizen.id)
        select "Helsinki", from: "signature_occupancy_county"
        uncheck "Vow"
        page.has_no_button? "Allekirjoita"
        check "Vow"
        page.has_button? "Allekirjaita"
      end
      
      scenario "7) citizen has not authenticated" do
        visit idea_page(idea.id)
        page.should_not have_link "Allekirjoita kannatusilmoitus ilman uutta tunnistautumista"
      end
      
      scenario "8) citizen doesn't give the vow" do
        pending "on which page we should land after visit_signature_idea_shortcut_fillin_path"
        visit_signature_finalize_signing(idea.id, @citizen.id)
        visit signature_idea_shortcut_fillin_path(another_idea.id)
        save_and_open_page
        uncheck "Vow"
        click_button "Allekirjoita"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
      end
      
      scenario "9) not logged in" do
        pending "on which page we should land after visit_signature_idea_shortcut_fillin_path"
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
          context "already attempted to sign", js: true do
            background do
              # AFAIK, @citizen can't be passed to let, therefore let can't be
              # used
              @signature = Signature.create_with_citizen_and_idea(@citizen, idea)
              @signature.accept_general = true
              @signature.accept_non_eu_server = true
              @signature.accept_publicity = "Normal"
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
              click_button "Eteenpäin"
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
          scenario "not attempted to sign before", js: true do
            visit_signature_finalize_signing(idea.id, @citizen.id)
            page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
          end
        end
      end
      context "authenticated", js: true do
        background do
          visit_signature_finalize_signing(another_idea.id, @citizen.id)
        end
        context "logged in" do
          context "already attempted to sign" do
            background do
              # AFAIK, @citizen can't be passed to let, therefore let can't be
              # used
              @signature = Signature.create_with_citizen_and_idea(@citizen, idea)
              @signature.accept_general = true
              @signature.accept_non_eu_server = true
              @signature.accept_publicity = "Normal"
            end
            scenario "existing signature has empty state" do
              pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
              @signature.state = ""
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the initial state" do
              pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
              @signature.state = "initial"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the authenticated state" do
              pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
              @signature.state = "authenticated"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the signed state" do
              pending "on which page we should land after visit_signature_idea_shortcut_fillin_path"
              @signature.state = "signed"
              @signature.save
              
              visit signature_idea_shortcut_fillin_path(idea.id)
              page.should have_content "Aiemmin allekirjoitettu"
              page.should_not have_button "Allekirjoita"
            end
            scenario "existing signature is at the invalid return state" do
              pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
              @signature.state = "invalid return"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the 'too late' state" do
              pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
              @signature.state = "too late"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
            scenario "existing signature is at the repeated_returning state" do
              pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
              @signature.state = "repeated_returning"
              @signature.save
              
              visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
              page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
            end
          end
          scenario "not attempted to sign before" do
            pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
            pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
            visit_signature_finalize_signing_after_shortcut_fillin(idea.id)
            page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
          end
        end
        scenario "not logged in" do
          pending "on which page we should land after visit_signature_finalize_signing_after_shortcut_fillin"
          logout
          visit signature_idea_shortcut_fillin_path(idea.id)
          should_be_on new_citizen_session_path
        end
      end
    end
  end
  
  context "white-box testing", js: true do
    context "change the account in the middle of signing" do
      scenario "change the account during authentication" do
        visit_signature_idea_path(idea.id)
        create_logged_in_citizen
        signature = Signature.where(:idea_id => idea.id,
          :citizen_id => @citizen.id).last
        visit(capybara_test_return_url(signature.id))
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_button "Allekirjoita"
      end
      scenario "change the account right before signing" do
        visit_signature_returning(idea.id, @citizen.id)
        create_logged_in_citizen
        select "Helsinki", from: "signature_occupancy_county"
        check "Vow"
        click_button "Allekirjoita"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
      end
    end
    scenario "invalid returning" do
      visit_signature_idea_path(idea.id)
      signature = Signature.where(:idea_id => idea.id,
        :citizen_id => @citizen.id).last
      
      service = "Capybaratesti"
      secret  = "capybaratesti"
      ENV["SECRET_#{service}"] = secret
      return_parameters = "B02K_VERS=0002&B02K_TIMESTMP=60020120708234854000001&B02K_IDNBR=0000004351&B02K_STAMP=2012070823484613889&B02K_CUSTNAME=DEMO+ANNA&B02K_KEYVERS=0001&B02K_ALG=03&B02K_CUSTID=010170-960F&B02K_CUSTTYPE=08"
      wrong_mac = mac(Random.new.bytes(100))
      
      visit "/signatures/#{signature.id}/returning/#{service}?#{return_parameters}&B02K_MAC=#{wrong_mac}"
      signature.reload
      
      page.should have_content "Tunnistaminen epäonnistui"
      page.should_not have_button "Allekirjoita"
      signature.state.should == "invalid return"
    end
    scenario "not within timelimit" do
      visit_signature_idea_path(idea.id)
      signature = Signature.where(:idea_id => idea.id,
        :citizen_id => @citizen.id).last
      Timecop.travel(Time.now + 30.minutes)
      visit(capybara_test_return_url(signature.id))
      Timecop.return
      signature.reload
      
      page.should have_content "Tunnistaminen epäonnistui"
      page.should_not have_button "Allekirjoita"
      signature.state.should == "too late"
    end
    scenario "repeated returning" do
      visit_signature_returning(idea.id, @citizen.id)
      signature = Signature.where(:idea_id => idea.id,
        :citizen_id => @citizen.id).last
      visit(capybara_test_return_url(signature.id))
      page.should have_content "Tunnistaminen epäonnistui"
      page.should_not have_button "Allekirjoita"
      signature.reload
      signature.state.should == "repeated_returning"
    end
    scenario "cancel authentication and change the account while signing" do
      visit_signature_idea_path(idea.id)
      create_logged_in_citizen
      signature = Signature.where(:idea_id => idea.id,
        :citizen_id => @citizen.id).last
      visit "/signatures/#{signature.id}/cancelling/Alandsbankentesti"
      page.should have_content "Tunnistaminen epäonnistui"
      page.should_not have_button "Allekirjoita"
    end
    context "authentication is rejected" do
      scenario "everything else is normal" do
        visit_signature_idea_path(idea.id)
        signature = Signature.where(:idea_id => idea.id,
          :citizen_id => @citizen.id).last
        visit "/signatures/#{signature.id}/rejecting/Capybaratesti"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_button "Allekirjoita"
        signature.reload
        signature.state.should == "rejected"
      end
      scenario "the citizen also changes the account while signing" do
        visit_signature_idea_path(idea.id)
        create_logged_in_citizen
        signature = Signature.where(:idea_id => idea.id,
                                    :citizen_id => @citizen.id).last
        visit "/signatures/#{signature.id}/rejecting/Capybaratesti"
        page.should have_content "Tunnistaminen epäonnistui"
        page.should_not have_button "Allekirjoita"
        signature.reload
        signature.state.should == "initial"
      end
    end
    scenario "the citizen attempts to use shortcut fillin but has not authenticated" do
      visit signature_idea_shortcut_fillin_path(idea.id)
      should_be_on signature_idea_introduction(idea.id)
    end
    # Third parties only need to know HTML (and probably look at the source
    # code) in order to create a form that sends users to
    # signature_shortcut_finalize_signing_path. Therefore we need to test for
    # that kind of attack.
    scenario "the citizen attempts to sign with shortcut_fillin but has not authenticated",
      :if => RUN_PUT_TESTS do
      # create a signature
      pending "on which page we should land after visit_signature_shortcut_finalize_signing_directly"
      visit_signature_idea_path(idea.id)
      signature = Signature.where(:idea_id => idea.id,
                                  :citizen_id => @citizen.id).last
      visit_signature_shortcut_finalize_signing_directly(signature.id,
                                                         idea.title,
                                                         @citizen.profile)
      should_be_on signature_idea_introduction(idea.id)
    end
    
    scenario "the citizen attempts to finalize signing with shortcut_fillin but has already signed the proposal",
      :if => RUN_PUT_TESTS do

      pending "on which page we should land after visit_signature_shortcut_finalize_signing_directly"
      visit_signature_returning(idea.id, @citizen.id)
      signature = Signature.where(:idea_id => idea.id,
                                  :citizen_id => @citizen.id).last
      pending "on which page we should land after visit_signature_shortcut_finalize_signing_directly"
      # sign the proposal
      visit_signature_returning(idea.id, @citizen.id)
      select "Helsinki", from: "signature_occupancy_county"
      check "Vow"
      click_button "Allekirjoita"
      page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
                                
      # attempt to sign again
      visit_signature_shortcut_finalize_signing_directly(signature.id,
                                                         idea.title,
                                                         @citizen.profile)
      page.should have_content "Previously signed"
      page.should_not have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
    end
    
    scenario "session['authenticated_at'] has an illegal value" do
      pending "move this test to cotroler layer"
      visit_signature_finalize_signing(idea.id, @citizen.id)
      Timecop.travel(Time.now - 1.minute)
      expect {visit idea_page(another_idea.id)}.to raise_error
      
      # BUG: If this test fails, the line below is not run and RSpec thinks that
      # the test took negative time. I'm not aware of any way to fix it.
      Timecop.return
    end
    
    scenario "the idea can't be signed and the citizen enters the URL manually" do
      idea_that_cannot_be_signed = FactoryGirl.create :idea
      visit signature_idea_introduction(idea_that_cannot_be_signed.id)
      page.should have_content "Can't be signed"
      page.should_not have_button "Siirry hyväksymään ehdot"
    end
    
    scenario "the idea can't be signed and the citizen attempts to enter the approval page directly", js: false do
      idea_that_cannot_be_signed = FactoryGirl.create :idea
      page.driver.post(signature_idea_approval_path(
          idea_that_cannot_be_signed.id))
      page.should have_content "Can't be signed"
      page.should_not have_button "Eteenpäin"
    end
    
    scenario "authentication expires before signing" do
      # probably signing should actually fail, but we're not testing for that
      # now
      visit_signature_returning(idea.id, @citizen.id)
      select "Helsinki", from: "signature_occupancy_county"
      check "Vow"
      Timecop.travel(Time.now + 30.minutes)
      click_button "Allekirjoita"
      Timecop.return
      
      page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
      page.should have_content "Tunnistautumisesi ei ole enää voimassa"
    end
  end
  
  context "attacks" do
    context "attempt to sign the proposal multiple times", js: true do
      background do
        # this time we send direct POST requests in order to bypass as many
        # security checks as possible
        visit_signature_idea_path(idea.id)
        @first_signature = Signature.where(:idea_id => idea.id,
                                          :citizen_id => @citizen.id).last
        # reload the page, which creates another signature
        visit_signature_idea_path(idea.id)
        @second_signature = Signature.where(:idea_id => idea.id,
                                           :citizen_id => @citizen.id).last
      end
      scenario "go to the returning page after signing for the first time" do
        # Try to complete the first signature
        visit(capybara_test_return_url(@first_signature.id))
        select "Helsinki", from: "signature_occupancy_county"
        check "Vow"
        click_button "Allekirjoita"
        page.should have_content "Kiitos kannatusilmoituksen allekirjoittamisesta"
        puts @first_signature.attributes
        # Try to complete the second signature
        service = "Capybaratesti"
        visit(capybara_test_return_url(@second_signature.id))
        page.should have_content "Aiemmin allekirjoitettu"
        page.should_not have_button "Allekirjoita"
      end
    end
  end

end