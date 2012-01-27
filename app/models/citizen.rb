class Citizen < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :profile, :profile_attributes
  
  has_one :profile, dependent: :destroy
  
  accepts_nested_attributes_for :profile
  
  [
    :first_name,
    :last_name,
    :name
  ].each { |attribute| delegate attribute, to: :profile }
end
