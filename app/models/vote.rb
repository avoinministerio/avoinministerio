class Vote < ActiveRecord::Base
  belongs_to :idea
  belongs_to :citizen
end
