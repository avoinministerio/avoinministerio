class AddFullNameToLanguages < ActiveRecord::Migration
  def change
    add_column :languages, :full_name, :string
  end
end
