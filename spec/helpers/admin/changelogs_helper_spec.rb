# encoding: UTF-8

require 'spec_helper'

describe Admin::ChangelogsHelper do
  describe "#short_diff" do
    it "should shorten the diff for a change" do
      original = <<-EOS
Lorem ipsum dolor sit amet, consectetur adipisicing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
nisi ut aliquip ex ea commodo consequat.
EOS
      updated = <<-EOS
Lorem ipsum dolor sit amet, consectetur adipisicing elit,
sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Lorem ipsum dolor sit amet, consectetur adipisicing elit.
Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
nisi ut aliquip ex ea commodo consequat.
EOS
      change = [original, updated]

      chars_around = Admin::ChangelogsHelper::CHARACTERS_AROUND_DIFF
      helper.short_diff(change).should =~ /&hellip; (.|\n){#{chars_around}}<del class="differ">qua.\nUt en<\/del><ins class="differ">qua.\nLorem ipsum dolor sit amet, consectetur adipisicing elit.\nUt en<\/ins>(.|\n){#{chars_around}} &hellip;/
    end

    it "should not shorten the diff unnecessarily" do
      change = ['', 'new value']
      helper.short_diff(change).should == '<ins class="differ">new value</ins>'
    end
  end

  describe "#changelogged_link_for" do
    it "should build a link for an Idea" do
      idea = Factory :idea
      link = helper.changelogged_link_for(idea.changelogs.last)
      link.should include("<a href=\"/ideat/#{idea.slug}\">Idea ##{idea.id}</a>")
    end

    it "should build a link for an Idea comment" do
      idea = Factory :idea
      comment = Factory :comment, commentable: idea
      link = helper.changelogged_link_for(comment.changelogs.last)
      link.should include("<a href=\"/ideat/#{idea.slug}#comments\">Kommentti ##{comment.id}</a>")
    end

    it "should build a link for an Article" do
      article = Factory :article
      link = helper.changelogged_link_for(article.changelogs.last)
      link.should include("<a href=\"/artikkelit/#{article.slug}\">Artikkeli ##{article.id}</a>")
    end

    it "should build a link for an Article comment" do
      article = Factory :article
      comment = Factory :comment, commentable: article
      link = helper.changelogged_link_for(comment.changelogs.last)
      link.should include("<a href=\"/artikkelit/#{article.slug}#comments\">Kommentti ##{comment.id}</a>")
    end
  end
end
