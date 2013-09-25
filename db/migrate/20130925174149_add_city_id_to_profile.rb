class AddCityIdToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :city_id, :integer
  end
end
