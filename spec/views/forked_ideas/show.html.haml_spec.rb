require 'spec_helper'

describe "forked_ideas/show" do
  before(:each) do
    @forked_idea = assign(:forked_idea, stub_model(ForkedIdea,
      :translated_ideas_at => 1,
      :author_id => 2,
      :title => "Title",
      :body => "MyText",
      :summary => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
