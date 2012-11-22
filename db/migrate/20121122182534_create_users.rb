class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :username , :string , :null => :false
      t.column :fullname , :string , :null => :false
      t.column :last_name , :string , :null => :false
      t.column :first_name , :string , :null => :false
      t.column :is_locked?  , :boolean , :default => :true
      t.column :door_no , :string , :null => :false
      t.column :street , :string , :null => :false
      t.column :state , :string , :null => :false
      t.column :pincode , :integer , :null => :false
      t.column :description , :text 
      t.column :primary_phone , :string , :null => :false
      t.column :secondary_phone , :string
      t.column :tertiary_phone , :string
      t.column :email_id , :string
      t.column :role_id , :integer , :null => :false

      t.column :total_credit , :integer , :null => :false
      t.column :credit_without_interest , :integer , :null => :false
      t.column :interest_for_credit , :integer , :null => :false
      t.column :total_debit , :integer , :null => :false
      t.column :debit_without_interest , :integer , :null => :false
      t.column :interest_for_debit , :integer , :null => :false
      t.timestamps
    end
  end
end
