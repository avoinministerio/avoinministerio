require 'spec_helper'

describe "forked_ideas/edit" do
  before(:each) do
    @forked_idea = assign(:forked_idea, stub_model(ForkedIdea,
      :translated_ideas_at => 1,
      :author_id => 1,
      :title => "MyString",
      :body => "MyText",
      :summary => "MyText"
    ))
  end

  it "renders the edit forked_idea form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", forked_idea_path(@forked_idea), "post" do
      assert_select "input#forked_idea_translated_ideas_at[name=?]", "forked_idea[translated_ideas_at]"
      assert_select "input#forked_idea_author_id[name=?]", "forked_idea[author_id]"
      assert_select "input#forked_idea_title[name=?]", "forked_idea[title]"
      assert_select "textarea#forked_idea_body[name=?]", "forked_idea[body]"
      assert_select "textarea#forked_idea_summary[name=?]", "forked_idea[summary]"
    end
  end
end
