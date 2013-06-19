class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, :limit => 50, :null => false
      t.string :iso, :limit => 5, :null => false

      t.timestamps
    end
  end
end
