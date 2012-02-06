class Citizen < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :profile, :profile_attributes
  
  has_one :profile, dependent: :destroy
  
  has_many :ideas, foreign_key: "author_id"
  has_many :comments, foreign_key: "author_id"
  has_many :idea_comments, through: :ideas
  
  accepts_nested_attributes_for :profile
  
  [
    :first_name,
    :last_name,
    :name
  ].each { |attribute| delegate attribute, to: :profile }
  
  private
  
  after_initialize do |citizen|
    citizen.build_profile unless citizen.profile
  end
end
