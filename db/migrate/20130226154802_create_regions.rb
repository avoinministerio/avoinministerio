class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.references :country, :null => false
      t.string :name, :limit => 45, :null => false
      t.string :iso, :limit => 5, :null => false

      t.timestamps
    end

    add_index :regions, :country_id, :name => 'index_regions_country_id'
  end
end
