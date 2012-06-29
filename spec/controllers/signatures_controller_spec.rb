require 'spec_helper'

describe SignaturesController do
  let (:citizen) { Factory :citizen }
  let (:idea) { Factory :idea }

  before do
    sign_in citizen
  end

  describe "POST sign" do
    before do
      @vote = Factory :vote, :citizen => citizen
      @comment = Factory :comment, :author => citizen
    end

    it "assigns the newly created Signature as @signature" do
      post :sign, :id => idea.id
      assigns(:signature).should_not be nil
    end

    it "assigns available authentication services as @services" do
      post :sign, :id => idea.id
      assigns(:services).length.should be 7
    end
  end
end
