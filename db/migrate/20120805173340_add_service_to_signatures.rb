class AddServiceToSignatures < ActiveRecord::Migration
  def up
    add_column    :signatures, :service, :string
  end
  def down
    remove_column :signatures, :service
  end
end
