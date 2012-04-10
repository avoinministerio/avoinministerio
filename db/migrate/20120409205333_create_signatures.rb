class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.references :citizen
      t.references :idea
      t.string :state

      t.timestamps
    end
  end
end
