class CreateAccountTables < ActiveRecord::Migration
  def up
    create_table :accounts do |t|
      t.column :name, :string
      t.column :accountable_id, :integer
      t.column :accountable_type, :string

      t.timestamps
    end

    create_table :account_transactions do |t|
      t.column :from_account_id, :integer , :null => false
      t.column :to_account_id, :integer , :null => false

      # for fixed due
      t.column :saving, :decimal , :default => 0, :precision => 2
      t.column :due, :decimal, :default => 0, :precision => 2

      # loan
      t.column :principle_debit, :decimal , :default => 0, :precision => 2
      
      # return
      t.column :principle_credit, :decimal , :default => 0, :precision => 2
      t.column :interest_credit, :decimal , :default => 0, :precision => 2

      t.timestamps
    end

  end

  def down
    drop_table :account_transactions
    drop_table :accounts
  end  

end
