class CreateTourings < ActiveRecord::Migration
  def change
    create_table :tourings do |t|
      t.string :tour_name
      t.integer :citizen_id
      t.string :state

      t.timestamps
    end
  end
end
