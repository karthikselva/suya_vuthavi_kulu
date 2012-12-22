class CreateAccountTables < ActiveRecord::Migration
  def up
    create_table :accounts do |t|
      t.column :name, :string
      t.column :accountable_id, :integer
      t.column :accountable_type, :string

      t.column :outstanding_balance, :decimal , :default => 0

      t.timestamps
    end

    create_table :account_tran_details do |t|
      t.column :from_account_id, :integer , :null => false
      t.column :to_account_id, :integer , :null => false
      t.column :transaction_date, :date

      # for fixed due
      t.column :saving, :decimal , :default => 0
      t.column :due, :decimal, :default => 0

      # loan
      t.column :principle_debit, :decimal , :default => 0
      
      # return
      t.column :principle_credit, :decimal , :default => 0
      t.column :interest_credit, :decimal , :default => 0
      t.column :other_amount, :decimal , :default => 0 

      t.column :from_outs_balance, :decimal , :default => 0 
      t.column :to_outs_balance, :decimal , :default => 0 

      t.timestamps
    end

  end

  def down
    drop_table :account_transactions
    drop_table :accounts
    drop_table :account_tran_details
  end  

end
