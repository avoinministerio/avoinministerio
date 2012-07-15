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
  let(:another_idea) {
    Factory :idea, state: "proposal", 
                  collecting_started: true, collecting_ended: false, 
                  collecting_start_date: today_date, collecting_end_date: today_date + 180, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:state_idea) {
    Factory :idea, state: "idea", 
                  collecting_started: false, collecting_ended: false, 
                  collecting_start_date: today_date + 1, collecting_end_date: today_date + 181, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:state_draft) {
    Factory :idea, state: "draft", 
                  collecting_started: false, collecting_ended: false, 
                  collecting_start_date: today_date + 1, collecting_end_date: today_date + 181, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:not_started_proposal) {
    Factory :idea, state: "proposal", 
                  collecting_started: false, collecting_ended: false, 
                  collecting_start_date: today_date + 1, collecting_end_date: today_date + 181, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
  }
  let(:ended_proposal) {
    Factory :idea, state: "proposal", 
                  collecting_started: true, collecting_ended: true, 
                  collecting_start_date: today_date - 181, collecting_end_date: today_date - 1, 
                  additional_signatures_count: 0, additional_signatures_count_date: today_date, 
                  target_count: 51500
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
    end
    scenario "Ended proposal" do
      citizen = create_logged_in_citizen({ :password => citizen_password, :email => citizen_email })
      visit idea_page(ended_proposal.id)
      page.should_not have_link("Allekirjoita")
    end

    scenario "Fail" do
      false.should_be true
    end

  end
  

end