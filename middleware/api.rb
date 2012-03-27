#lib/api.rb
require 'grape'

module AmApi
  class Api < Grape::API
    prefix "api"
 
    resource "ideas" do
      get do
        Idea.all
      end
 
      get ':id' do
        Idea.find(params[:id])
      end
    end
 
  end
end
