class AddRankToState < ActiveRecord::Migration
  def change
    add_column :states, :rank, :integer, :default => 1
  end
end
