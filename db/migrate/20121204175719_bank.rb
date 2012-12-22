class Bank < ActiveRecord::Migration
  def up
  	create_table :banks do |t|
      t.column :bank_name , :string
      t.column :branch , :string 
      t.column :account_name , :string 
      t.column :account_number , :string 
      t.timestamps
    end
  end

  def down
  	drop_table :banks
  end
end
