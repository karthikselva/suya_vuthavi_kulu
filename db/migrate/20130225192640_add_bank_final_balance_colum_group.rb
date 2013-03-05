class AddBankFinalBalanceColumGroup < ActiveRecord::Migration
  def up
  	account = Account.new(:name => "Expences") 
    account.save
    account.update_attributes(:accountable_id => account.id, :accountable_type => account.class.to_s)

  	add_column :groups, :bank_final_balance, :decimal, :default => 0
  end

  def down
  	remove_column :groups, :bank_final_balance
  end
end
