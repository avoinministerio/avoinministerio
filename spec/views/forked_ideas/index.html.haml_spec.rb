require 'spec_helper'

describe "forked_ideas/index" do
  before(:each) do
    assign(:forked_ideas, [
      stub_model(ForkedIdea,
        :translated_ideas_at => 1,
        :author_id => 2,
        :title => "Title",
        :body => "MyText",
        :summary => "MyText"
      ),
      stub_model(ForkedIdea,
        :translated_ideas_at => 1,
        :author_id => 2,
        :title => "Title",
        :body => "MyText",
        :summary => "MyText"
      )
    ])
  end

  it "renders a list of forked_ideas" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
