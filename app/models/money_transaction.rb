class MoneyTransaction < ActiveRecord::Base
  attr_accessible :amount, :description, :unique_identifier
  belongs_to :citizen

  validates :unique_identifier, :uniqueness => true
end
