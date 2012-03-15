require 'spec_helper'

describe "expert_suggestions/edit" do
  before(:each) do
    @expert_suggestion = assign(:expert_suggestion, stub_model(ExpertSuggestion,
      :firstname => "MyString",
      :lastname => "MyString",
      :email => "MyString",
      :title => "MyString",
      :organisation => "MyString",
      :expertise => "MyString",
      :recommendation => "MyString",
      :supporter => ""
    ))
  end

  it "renders the edit expert_suggestion form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => expert_suggestions_path(@expert_suggestion), :method => "post" do
      assert_select "input#expert_suggestion_firstname", :name => "expert_suggestion[firstname]"
      assert_select "input#expert_suggestion_lastname", :name => "expert_suggestion[lastname]"
      assert_select "input#expert_suggestion_email", :name => "expert_suggestion[email]"
      assert_select "input#expert_suggestion_title", :name => "expert_suggestion[title]"
      assert_select "input#expert_suggestion_organisation", :name => "expert_suggestion[organisation]"
      assert_select "input#expert_suggestion_expertise", :name => "expert_suggestion[expertise]"
      assert_select "input#expert_suggestion_recommendation", :name => "expert_suggestion[recommendation]"
      assert_select "input#expert_suggestion_supporter", :name => "expert_suggestion[supporter]"
    end
  end
end
