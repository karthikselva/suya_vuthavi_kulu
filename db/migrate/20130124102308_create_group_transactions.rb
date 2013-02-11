class CreateGroupTransactions < ActiveRecord::Migration
  def up
  	create_table :group_trans_tracks do |t|
  	  t.column :account_tran_detail_id, :integer	
      t.column :from_account_id, :integer , :null => false
      t.column :to_account_id, :integer , :null => false
      t.column :transaction_date, :date

      # their balances
      t.column :from_to_outs_balance, :decimal , :default => 0 
      t.column :to_from_outs_balance, :decimal , :default => 0

      t.timestamps
    end
  end

  def down
  	drop_table :group_trans_tracks
  end
end
