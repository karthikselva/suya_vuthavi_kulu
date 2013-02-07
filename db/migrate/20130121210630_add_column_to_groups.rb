class AddColumnToGroups < ActiveRecord::Migration
  
  def up
    add_column :groups, :saving_amount, :decimal, :default => 0
    add_column :groups, :due_amount, :decimal, :default => 0
  end

  def down
    remove_column :groups, :saving_amount
    remove_column :groups, :due_amount
  end	

end
