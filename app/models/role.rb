class Role < ActiveRecord::Base

  has_and_belongs_to_many :users
  has_many :roles_user

  def Role.update_roles_users
  	users = User.where("email != 'dheleepkumar1992@gmail.com'")
  	role = Role.find_by_name("Normal")
  	for user in users
  	  roles_user = RolesUser.new(:role_id => role.id, :user_id => user.id)	
  	  roles_user.save
  	end
    
    user = User.where(:email => "dheleepkumar1992@gmail.com").first	
    role = Role.find_by_name("Admin")
    roles_user = RolesUser.new(:role_id => role.id, :user_id => user.id)  
    roles_user.save
  end	

end
