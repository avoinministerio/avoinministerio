class ExpertSuggestion < ActiveRecord::Base
  belongs_to :idea
  belongs_to :supporter, class_name: "Citizen", foreign_key: "citizen_id"

  validates_presence_of :idea
  validates_presence_of :supporter
 
  attr_accessible :firstname, :lastname, :email, :jobtitle, :organisation, :expertise, :recommendation
end
