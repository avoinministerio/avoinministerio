class MoneyTransactions < ActiveRecord::Base
  attr_accessible :amount, :description
  belongs_to :citizen
end
