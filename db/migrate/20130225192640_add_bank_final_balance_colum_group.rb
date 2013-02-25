class AddBankFinalBalanceColumGroup < ActiveRecord::Migration
  def up
  	add_column :groups, :bank_final_balance, :decimal
  end

  def down
  	remove_column :groups, :bank_final_balance
  end
end
