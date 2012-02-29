class Profile < ActiveRecord::Base
  belongs_to :citizen

  attr_accessible :first_name, :last_name, :image
  
  validates_presence_of :first_name, :last_name
  
  def name
    "#{first_name} #{last_name}"
  end
end
