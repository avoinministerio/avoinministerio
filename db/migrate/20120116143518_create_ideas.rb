class CreateIdeas < ActiveRecord::Migration
  def change
    create_table :ideas do |t|
      t.string      :title
      t.text        :body
      t.string      :state
      t.integer     :author_id

      t.timestamps
    end
  end
end
