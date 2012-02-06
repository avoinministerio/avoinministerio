class Idea < ActiveRecord::Base
  has_many :comments, as: :commentable
  
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
end
