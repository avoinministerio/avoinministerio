require 'spec_helper'

describe "expert_suggestions/index" do
  before(:each) do
    assign(:expert_suggestions, [
      stub_model(ExpertSuggestion,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :email => "Email",
        :title => "Title",
        :organisation => "Organisation",
        :expertise => "Expertise",
        :recommendation => "Recommendation",
        :supporter => ""
      ),
      stub_model(ExpertSuggestion,
        :firstname => "Firstname",
        :lastname => "Lastname",
        :email => "Email",
        :title => "Title",
        :organisation => "Organisation",
        :expertise => "Expertise",
        :recommendation => "Recommendation",
        :supporter => ""
      )
    ])
  end

  it "renders a list of expert_suggestions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Organisation".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Expertise".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Recommendation".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
