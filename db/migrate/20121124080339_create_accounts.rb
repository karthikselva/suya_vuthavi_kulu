class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.column :accountable_type , :string
      t.column :accountable_id , :integer 
      t.timestamps
    end
  end
end
