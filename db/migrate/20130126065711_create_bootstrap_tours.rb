class CreateBootstrapTours < ActiveRecord::Migration
  def change
    create_table :bootstrap_tours do |t|
      t.integer :user_id
      t.string :controller
      t.string :action
      t.integer :step
      t.boolean :is_ended

      t.timestamps
    end
  end
end
