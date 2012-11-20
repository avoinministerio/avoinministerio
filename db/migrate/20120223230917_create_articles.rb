class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string   :title
      t.text     :ingress
      t.text     :body
      t.string   :article_type
      t.references :idea
      t.references :citizen

      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
