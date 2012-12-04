class Bank < ActiveRecord::Migration
  def up
  	create_table :banks do |t|
      t.column :bank_name , :string
      t.column :baranch , :integer 
      t.column :account_name , :integer 
      t.column :account_number , :integer 
      t.timestamps
    end
  end

  def down
  	drop_table :banks
  end
end
