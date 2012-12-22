class GroupsUser < ActiveRecord::Base
  attr_accessible :group_id, :user_id, :is_admin
  belongs_to :group
  belongs_to :user
end
