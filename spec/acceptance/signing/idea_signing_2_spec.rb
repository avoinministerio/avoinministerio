# -*- encoding: utf-8 -*-
require "acceptance/acceptance_helper"
require 'webmock/rspec'

include ApplicationHelper

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
                  target_count: 51500,
                  additional_collecting_service_urls: "http://www.example.com/initiative"
  }
  let(:another_idea) {
    Factory :idea, state: "proposal", 
                  collecting_in_service: true,
                  collecting_started: true, collecting_ended: false, 
                  collecting_start_date: today_date, collecting_end_date: today_date + 180, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:state_idea) {
    Factory :idea, state: "idea", 
                  collecting_in_service: false,
                  collecting_started: false, collecting_ended: false, 
                  collecting_start_date: today_date + 1, collecting_end_date: today_date + 181, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:state_draft) {
    Factory :idea, state: "draft", 
                  collecting_in_service: false,
                  collecting_started: false, collecting_ended: false, 
                  collecting_start_date: today_date + 1, collecting_end_date: today_date + 181, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:not_started_proposal) {
    Factory :idea, state: "proposal", 
                  collecting_in_service: true,
                  collecting_started: false, collecting_ended: false, 
                  collecting_start_date: today_date + 1, collecting_end_date: today_date + 181, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:ended_proposal) {
    Factory :idea, state: "proposal", 
                  collecting_in_service: true,
                  collecting_started: true, collecting_ended: true, 
                  collecting_start_date: today_date - 181, collecting_end_date: today_date - 1, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:signature) {
    Factory :signature, idea: idea
  }

  context "Sign button on Idea page visible" do
    scenario "Not logged in user gets to log in to sign" do
      visit idea_page(idea.id)
      page.should have_link("Sisäänkirjaudu allekirjoittaaksesi kannatusilmoituksen")
    end
    scenario "Logged in user gets to sign" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit idea_page(idea.id)
      page.should have_link("Allekirjoita kannatusilmoitus")
      page.should have_content("Keruu on käynnissä")
      page.should have_content("Käynnistynyt " + finnishDate(today_date))
      page.should have_content("Keräys päättyy " + finnishDate(today_date + 180))
      page.should have_content("Kerääminen muualla")
      page.should have_link("http://www.example.com/initiative")
      
      page.should have_content("Kerätty keskimäärin 0.0 kpl / päivä")
      page.should_not have_content("Tällä tahdilla kerääminen kestänee kaikkiaan")
      page.should_not have_content("Tavoite on täyttynyt")
      page.should_not have_content("Kannatusilmoitusten keräys on päättynyt")
    end
    scenario "Ideas cannot be signed" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit idea_page(state_idea.id)
      page.should_not have_link("Allekirjoita")
    end
    scenario "Drafts cannot be signed" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit idea_page(state_draft.id)
      page.should_not have_link("Allekirjoita")
    end
    scenario "Not started proposals cannot be signed" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit idea_page(not_started_proposal.id)
      page.should_not have_link("Allekirjoita")
#      page.should have_content("Keruu on alkamatta")
#      page.should have_content("Käynnistymässä " + finnishDate(today_date + 1))
      page.should_not have_content("Kerätty keskimäärin")
    end
    scenario "Ended proposal" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit idea_page(ended_proposal.id)
      page.should_not have_link("Allekirjoita")
#      page.should have_content("Keruu on päättynyt")
#      page.should have_content("Keräys päättyi " + finnishDate(today_date - 1))
#      page.should have_content("Kannatusilmoitusten keräys on päättynyt")
    end
    scenario "There are no additional collecting service URLs" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit idea_page(another_idea.id)
      page.should_not have_content("Kerääminen muualla")
    end
    scenario "Idea is on going and has got a signature" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      signature
      visit idea_page(idea.id)
      total_days_to_reach_target = (idea.target_count) / idea.signatures_per_day
      
      page.should have_content("Tällä tahdilla kerääminen kestänee kaikkiaan #{sprintf('%.1f', total_days_to_reach_target)} päivää")
      page.should have_content("Tällä tahdilla ei ehditä kerätä ilmoituksia riittävästi ennen päättymispäivää")
    end
    scenario "Idea is about to pass" do
      idea_about_to_pass = Factory :idea, state: "proposal", 
                  collecting_in_service: true,
                  collecting_started: true, collecting_ended: false, 
                  collecting_start_date: today_date, collecting_end_date: today_date + 180, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 10
      signature_for_idea_about_to_pass = Factory :signature, idea: idea_about_to_pass
      
      visit idea_page(idea_about_to_pass.id)
      page.should have_content("Tällä tahdilla ehditään kerätä ilmoitukset ennen päättymispäivää")
    end
    scenario "Idea has passed" do
      passed_idea = Factory :idea, state: "proposal", 
                  collecting_in_service: true,
                  collecting_started: true, collecting_ended: false, 
                  collecting_start_date: today_date, collecting_end_date: today_date + 180, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 1
      signature_for_passed_idea = Factory :signature, idea: passed_idea
      
      visit idea_page(passed_idea.id)
      page.should have_content("Tavoite on täyttynyt")
    end

    scenario "Fail" do
#      false.should_be true
    end

  end
  

end