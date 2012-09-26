class CreateMoneyTransactions < ActiveRecord::Migration
  def change
    create_table :money_transactions do |t|
      t.references  :citizen
      t.decimal     :amount, precision: 8, scale: 2
      t.string      :description

      t.timestamps
    end
  end
end
