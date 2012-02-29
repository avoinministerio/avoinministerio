class Article < ActiveRecord::Base
  include PublishingStateMachine
  
  belongs_to :idea
  belongs_to :author, class_name: "Citizen", foreign_key: "citizen_id"
end
