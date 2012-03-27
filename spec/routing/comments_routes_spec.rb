require 'spec_helper'

describe "comments resource routes" do
  describe "#create" do
    it "routes /ideat/:idea.id-:idea.slug/kommentit to CommentsController#create" do
      { post: 'http://localhost/ideat/123-allow-citizen-initiatives/kommentit' }.should route_to(
        locale: 'fi',
        controller: 'comments',
        idea_id: '123-allow-citizen-initiatives',
        action: 'create'
      )
    end

    it "routes /artikkelit/:article.id-:article.slug/kommentit to IdeasController#show" do
      { post: 'http://localhost/artikkelit/321-allow-citizen-initiatives/kommentit' }.should route_to(
        locale: 'fi',
        controller: 'comments',
        article_id: '321-allow-citizen-initiatives',
        action: 'create'
      )
    end
  end
end
