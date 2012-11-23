class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.column :name , :string , :null => false
      t.column :description , :text
      t.timestamps
    end
  end
end
