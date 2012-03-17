class ExpertSuggestion < ActiveRecord::Base
	belongs_to :idea
  	belongs_to :supporter, class_name: "Citizen", foreign_key: "citizen_id"
 
   attr_accessible :firstname, :lastname, :email, :title, :organisation, :expertise, :recommendation
end
