class AddUniqueIdentifierToMoneyTransaction < ActiveRecord::Migration
  def change
    change_table :money_transactions do |table|
      table.string :unique_identifier, length: 64, unique: true
    end
  end
end
