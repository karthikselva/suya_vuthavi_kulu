class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.column :name , :string , :null => false
      t.column :description , :text 
      t.column :group_admin_id , :integer 
      t.column :total_amount , :decimal
      t.column :principal_amount , :integer 
      t.column :interest_amount , :integer 
      t.timestamps
    end
  end
end
