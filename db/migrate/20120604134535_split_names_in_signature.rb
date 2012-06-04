class SplitNamesInSignature < ActiveRecord::Migration
  def up
    add_column 		:signatures, :firstnames, :string
    add_column 		:signatures, :lastname, :string
    remove_column 	:signatures, :fullname
  end
  def down
    remove_column 	:signatures, :firstnames
    remove_column 	:signatures, :lastname
    add_column 		:signatures, :fullname, :string
  end
end
