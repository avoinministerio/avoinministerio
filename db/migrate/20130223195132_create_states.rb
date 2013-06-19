class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.integer :administrator_id
      t.string :name

      t.timestamps
    end

    add_index :states, :name, :name => 'indx_states_name'
  end
end