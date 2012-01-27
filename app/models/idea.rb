class Idea < ActiveRecord::Base
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
end
