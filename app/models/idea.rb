class Idea < ActiveRecord::Base
  has_many :comments, as: :commentable
  has_many :articles
  
  belongs_to :author, class_name: "Citizen", foreign_key: "author_id"
end
