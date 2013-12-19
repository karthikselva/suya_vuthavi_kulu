class AddUserPosition < ActiveRecord::Migration
  def up
  	add_column :users, :position, :integer, :default => 0
  end

  def down
  	remove_column :users, :position
  end
end
