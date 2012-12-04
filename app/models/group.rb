class Group < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :account, :as => :accountable
  has_many :groups_users
  has_many :users, :through => :groups_users
end
