class CreateBootstrapTours < ActiveRecord::Migration
  def change
    create_table :bootstrap_tours do |t|
      t.string :user_id
      t.string :integer
      t.string :controller
      t.string :action
      t.string :step
      t.string :integer
      t.string :is_ended
      t.string :boolean

      t.timestamps
    end
  end
end
