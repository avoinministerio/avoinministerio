class Politician < ActiveRecord::Base
  attr_accessible :city_id, :name

  belongs_to :political_party
end
