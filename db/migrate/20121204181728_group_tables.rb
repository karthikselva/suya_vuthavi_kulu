class GroupTables < ActiveRecord::Migration
  def up
  	create_table :groups do |t|
      t.column :name , :string
      t.timestamps
    end
    create_table :groups_users do |t|
      t.column :group_id , :integer
      t.column :user_id , :integer
      t.column :is_admin , :boolean, :default => false
      t.timestamps
    end
  end

  def down
  	drop_table :groups
  	drop_table :groups_users
  end
end
