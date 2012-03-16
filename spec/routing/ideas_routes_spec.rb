require 'spec_helper'

describe "ideas resource routes" do
  describe "#show" do
    it "routes /ideat/:idea.slug to IdeasController#show" do
      { get: 'http://localhost/ideat/allow-citizen-initiatives' }.should route_to(
        locale: 'fi',
        controller: 'ideas',
        action: 'show',
        id: 'allow-citizen-initiatives'
      )
    end

    it "routes /ideat/:idea.id-:idea.slug to IdeasController#show" do
      { get: 'http://localhost/ideat/123-allow-citizen-initiatives' }.should route_to(
        locale: 'fi',
        controller: 'ideas',
        action: 'show',
        id: '123-allow-citizen-initiatives'
      )
    end
  end
end
