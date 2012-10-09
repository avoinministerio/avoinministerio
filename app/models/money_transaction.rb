class MoneyTransaction < ActiveRecord::Base
  attr_accessible :amount, :description
  belongs_to :citizen
end
