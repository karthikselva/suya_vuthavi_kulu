class CreateMonthlyBuckets < ActiveRecord::Migration
  def up
  	create_table :monthly_buckets do |t|
      t.column :group_id, :integer
      t.column :date, :date
      t.column :final_balance, :decimal, :default => 0
      t.column :bank_final_balance, :decimal, :default => 0

      t.timestamps
    end

    remove_column :groups, :final_balance
    remove_column :groups, :bank_final_balance

  end

  def down
  	drop_table :monthly_buckets

    add_column :groups, :final_balance, :decimal, :default => 0
  	add_column :groups, :bank_final_balance, :decimal, :default => 0
  end
end
