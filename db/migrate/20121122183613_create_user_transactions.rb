class CreateUserTransactions < ActiveRecord::Migration
  def change
    create_table :user_transactions do |t|
      t.column :user_id , :integer , :null => false
      t.column :monthly_bucket_id , :integer 

      t.column :past_credit , :integer , :null => false
      t.column :current_credit , :integer , :null => false

      t.column :past_debit , :integer , :null => false
      t.column :current_debit , :integer , :null => false

      t.column :amount_received_in_hand , :integer , :null => false
      t.column :amount_deposited_to_group , :integer , :null => false

      t.column :current_group_interest , :integer , :null => false
      t.timestamps
    end
  end
end
