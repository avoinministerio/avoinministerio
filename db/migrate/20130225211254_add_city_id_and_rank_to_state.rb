class AddCityIdAndRankToState < ActiveRecord::Migration
  def change
    add_column :states, :city_id, :integer, :allow_null => false
    add_column :states, :rank, :integer, :default => 1
  end
end
