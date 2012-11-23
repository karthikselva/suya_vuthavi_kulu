class CreateMonthlyBuckets < ActiveRecord::Migration
  def change
    create_table :monthly_buckets do |t|
      t.column :user_id , :integer , :null => false
      t.column :bucket_start_date , :date , :null => false
      t.column :paid_date , :datetime , :null => false
      t.column :paid_total_amt , :decimal , :null => false
      t.column :paid_due_amt , :decimal , :null => false
      t.column :paid_interest_amt , :decimal
      t.column :balance_amt , :decimal , :null => false
      t.timestamps
    end
  end
end
