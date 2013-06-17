class ChangeStateToIntegerInIdea < ActiveRecord::Migration
  def up
    admin_id = Administrator.first.id
    states = Idea.pluck(:state)

    remove_column :ideas, :state
    add_column :ideas, :state_id, :integer

    Idea.all.each_with_index do |idea, index|
      state = State.find_or_create_by_name(:name => states[index], :administrator_id => admin_id.to_i)
      idea.update_attribute(:state_id, state.id.to_i)
    end
  end

  # It will not add state attr values back
  def down
    remove_column :ideas, :state_id
    add_column :ideas, :state, :string
  end
end