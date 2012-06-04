class AddStampToSignatures < ActiveRecord::Migration
  def up
    add_column 		:signatures, :stamp, :boolean
  end
  def down
    remove_column 	:signatures, :stamp
  end
end
