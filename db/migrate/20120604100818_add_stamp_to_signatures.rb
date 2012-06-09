class AddStampToSignatures < ActiveRecord::Migration
  def up
    add_column 		:signatures, :stamp, 	:string
    add_column 		:signatures, :started, 	:datetime
  end
  def down
    remove_column 	:signatures, :stamp
    remove_column 	:signatures, :started
  end
end
