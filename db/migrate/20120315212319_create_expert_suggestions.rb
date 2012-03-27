class CreateExpertSuggestions < ActiveRecord::Migration
  def change
    create_table :expert_suggestions do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :jobtitle
      t.string :organisation
      t.string :expertise
      t.string :recommendation
      t.references :citizen
      t.references :idea

      t.timestamps
    end
  end
end
