class CreateGroupDetails < ActiveRecord::Migration
  def change
    create_table :group_details do |t|
      t.column :attribute , :string , :null => :false
      t.column :value , :string 
      t.column :type , :string , :default => "string"
      t.timestamps
    end
  end
end
