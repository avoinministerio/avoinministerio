class ChangeStateToIntegerInIdea < ActiveRecord::Migration
  def up
    remove_column :ideas, :state
    add_column :ideas, :state_id, :integer
  end

  def down
    remove_column :ideas, :state_id
    add_column :ideas, :state, :string
  end
end