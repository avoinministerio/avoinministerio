require 'spec_helper'

describe Article do
  it { should belong_to :author }
  it { should ensure_length_of(:title).is_at_least(5).with_short_message(/on liian lyhyt/) }

  let(:article) { Factory(:article) }

  it "should be valid" do
    article.should be_valid
  end

  it "should have a valid article_type" do
    article.article_type = 'invalid'
    article.should_not be_valid
    article.errors[:article_type].should include("invalid ei ole sallittu artikkelityyppi")
  end
end
