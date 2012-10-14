class AddAuthenticatedFieldsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :authenticated_firstnames, :string
    add_column :profiles, :authenticated_lastname, :string
    add_column :profiles, :authenticated_birth_date, :string
    add_column :profiles, :authenticated_occupancy_county, :string
  end
end
