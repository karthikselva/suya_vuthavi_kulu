class CreateAccountTransactions < ActiveRecord::Migration
  def change
    create_table :account_transactions do |t|

      t.column :from_account_id , :integer 
      t.column :to_account_id , :integer

# Amount payed by Member to Group
      t.column :due_amount , :decimal , :default => 0

# Valid if member has any loan
      t.column :principle_credit_amount , :decimal , :default => 0 
      t.column :principle_interest_amount , :decimal , :default => 0 

# Amount sanctioned from Group to Member 
      t.column :principle_debit_amount , :decimal , :default => 0 

      t.timestamps
    end
  end
end
