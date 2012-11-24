class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :username , :string , :null => false
      t.column :fullname , :string 
      t.column :last_name , :string 
      t.column :first_name , :string 
      t.column :is_locked  , :boolean , :default => true
      t.column :door_no , :string 
      t.column :street , :string 
      t.column :state , :string 
      t.column :pincode , :integer 
      t.column :description , :text 
      t.column :primary_phone , :string 
      t.column :secondary_phone , :string
      t.column :tertiary_phone , :string
      t.column :email_id , :string
      t.column :role_id , :integer 

      t.column :total_credit , :decimal , :default => 0 , :null => false
      t.column :credit_without_interest , :decimal , :default => 0 , :null => false
      t.column :interest_for_credit , :decimal , :default => 0 , :null => false
      t.column :total_debit , :decimal , :default => 0 , :null => false
      t.column :debit_without_interest , :decimal , :default => 0 , :null => false
      t.column :interest_for_debit , :decimal , :default => 0 , :null => false

      t.column :group_id , :integer
      t.timestamps
    end
  end
end
