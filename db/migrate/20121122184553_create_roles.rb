class CreateRoles < ActiveRecord::Migration
  def up
    create_table :roles do |t|
      t.column :name , :string , :null => false
      t.column :description , :text
      t.timestamps
    end

  end

  def down
  	drop_table :roles
  end	

end
