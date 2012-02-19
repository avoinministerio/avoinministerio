require 'spec_helper'

describe VoteController do

  describe "GET 'vote_for'" do
    it "returns http success" do
      get 'vote_for'
      response.should be_success
    end
  end

  describe "GET 'vote_against'" do
    it "returns http success" do
      get 'vote_against'
      response.should be_success
    end
  end

end
