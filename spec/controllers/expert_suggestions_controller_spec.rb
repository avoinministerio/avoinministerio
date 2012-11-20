require 'spec_helper'

describe ExpertSuggestionsController do

  before :each do
    @citizen = Factory.create :citizen
    sign_in @citizen
    @idea = Factory :idea
    @valid_attributes = {
        firstname: 'Erkki',
        lastname: 'Esimerkki',
        email: 'erkki@asiantuntija.fi',
        jobtitle: 'Asiantuntija',
        organisation: 'Asiantuntijat Oy',
        expertise: '',
        recommendation: ''
      }
  end

  describe "POST create" do
    it "creates a new ExpertSuggestion" do
      expect {
        post :create, { idea_id: @idea.id, expert_suggestion: @valid_attributes }
      }.to change(ExpertSuggestion, :count).by(1)
    end

    it "assigns a newly created expert_suggestion as @expert_suggestion" do
      post :create, { idea_id: @idea.id, expert_suggestion: @valid_attributes }
      assigns(:expert_suggestion).should be_a(ExpertSuggestion)
      assigns(:expert_suggestion).should be_persisted
    end

    it "redirects to the created expert_suggestion" do
      post :create, { idea_id: @idea.id, expert_suggestion: @valid_attributes }
      response.should redirect_to(ExpertSuggestion.last.idea)
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved expert_suggestion as @expert_suggestion" do
        ExpertSuggestion.any_instance.stub(:save).and_return(false)
        post :create, { idea_id: @idea.id, expert_suggestion: {} }
        assigns(:expert_suggestion).should be_a_new(ExpertSuggestion)
      end

      it "re-renders the 'new' template" do
        ExpertSuggestion.any_instance.stub(:save).and_return(false)
        post :create, { idea_id: @idea.id, expert_suggestion: {} }
        response.should render_template("new")
      end
    end

    describe "no citizen logged in" do
      before :each do
        sign_out @citizen
      end

      it "should authenticate citizen" do
        post :create, { idea_id: @idea.id, expert_suggestion: @valid_attributes }
        response.should_not be_success
        response.should redirect_to(new_citizen_session_path)
      end
    end
  end
end
