class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author_id
      t.text :body
      t.boolean :published, default: true
      t.integer :commentable_id
      t.string :commentable_type

      t.timestamps
    end
  end
end
