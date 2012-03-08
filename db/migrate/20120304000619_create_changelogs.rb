class CreateChangelogs < ActiveRecord::Migration
  def change
    create_table :changelogs do |t|
      t.string :changer_type
      t.integer :changer_id
      t.string :changelogged_type
      t.integer :changelogged_id
      t.string :change_type
      t.text :attribute_changes

      t.timestamps
    end
    add_index :changelogs, [:changer_type, :changer_id]
    add_index :changelogs, [:changelogged_type, :changelogged_id]
  end
end
