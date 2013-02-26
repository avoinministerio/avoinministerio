class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.references :region, :null => false
      t.string :name, :limit => 100, :null => false

      t.timestamps
    end

    add_index :cities, :region_id, :name => 'index_cities_region_id'
  end
end
