class Users < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :user_transactions
  belongs_to :role
end
