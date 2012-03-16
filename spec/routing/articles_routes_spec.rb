require 'spec_helper'

describe "articles resource routes" do
  describe "#show" do
    it "routes /artikkelit/:article.slug to ArticlesController#show" do
      { get: 'http://localhost/artikkelit/uusi-artikkeli' }.should route_to(
        locale: 'fi',
        controller: 'articles',
        action: 'show',
        id: 'uusi-artikkeli'
      )
    end

    it "routes /artikkelit/:article.id-:article.slug to ArticlesController#show" do
      { get: 'http://localhost/artikkelit/1-uusi-artikkeli' }.should route_to(
        locale: 'fi',
        controller: 'articles',
        action: 'show',
        id: '1-uusi-artikkeli'
      )
    end
  end
end
