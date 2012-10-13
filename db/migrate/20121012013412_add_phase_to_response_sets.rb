class AddPhaseToResponseSets < ActiveRecord::Migration
  def change
    add_column :response_sets, :user_state, :string
  end
end
