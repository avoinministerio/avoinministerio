require 'spec_helper'

describe Article do
  before :each do
    @article = Factory.build :article
  end

  it "should be valid" do
    @article.should be_valid
  end

  it "should have a valid article_type" do
    @article.article_type = 'invalid'
    @article.should_not be_valid
    @article.errors[:article_type].should include("invalid ei ole sallittu artikkelityyppi")
  end
end
