class AddCityIdToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :city_id, :integer
    add_index :ideas, :city_id, :name => 'inx_ida_city'
  end
end
