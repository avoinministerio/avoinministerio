class SplitNamesInSignature < ActiveRecord::Migration
  def up
    add_column 		:signatures, :firstnames, :string
    add_column 		:signatures, :lastname, :string
    remove_column 	:signatures, :fullname, :string
  end
  def down
    remove_column 	:signatures, :firstnames, :string
    remove_column 	:signatures, :lastname, :string
    add_column 		:signatures, :fullname
  end
end
