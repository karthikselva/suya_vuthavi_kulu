class AddColumnToAccTranDetails < ActiveRecord::Migration
  def up
    add_column :account_tran_details, :comments, :text
    add_column :groups, :final_balance, :decimal
  end

  def down
    remove_column :account_tran_details, :comments
    remove_column :groups, :final_balance
  end
end
