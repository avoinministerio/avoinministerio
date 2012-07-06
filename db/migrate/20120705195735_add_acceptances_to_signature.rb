class AddAcceptancesToSignature < ActiveRecord::Migration
  def up
    add_column :signatures, :accept_general,          :boolean
    add_column :signatures, :accept_non_eu_server,    :boolean
    add_column :signatures, :accept_publicity,        :string
    add_column :signatures, :accept_science,          :boolean

    add_column :signatures, :idea_mac,                :string
  end
  def down
    remove_column :signatures, :accept_general
    remove_column :signatures, :accept_non_eu_server
    remove_column :signatures, :accept_publicity
    remove_column :signatures, :accept_science

    remove_column :signatures, :idea_mac
  end
end
