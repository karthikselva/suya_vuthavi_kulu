class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :first_name , :string , :null => false
      t.column :last_name , :string , :null => false
      t.column :dob, :date
      t.column :is_locked  , :boolean
      t.column :door_no , :string
      t.column :street , :string 
      t.column :state , :string
      t.column :pincode , :integer 
      t.column :description , :text 
      t.column :primary_phone , :string
      t.column :secondary_phone , :string
      t.column :tertiary_phone , :string
      t.column :role_id , :integer

      t.timestamps
    end
  end
end
