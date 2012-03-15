require 'spec_helper'

describe "expert_suggestions/show" do
  before(:each) do
    @expert_suggestion = assign(:expert_suggestion, stub_model(ExpertSuggestion,
      :firstname => "Firstname",
      :lastname => "Lastname",
      :email => "Email",
      :title => "Title",
      :organisation => "Organisation",
      :expertise => "Expertise",
      :recommendation => "Recommendation",
      :supporter => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Firstname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Lastname/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Organisation/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Expertise/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Recommendation/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
  end
end
