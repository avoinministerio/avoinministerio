class Authentication < ActiveRecord::Base
  belongs_to :citizen
  validates_presence_of :citizen
end
