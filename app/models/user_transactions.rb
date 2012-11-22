class UserTransactions < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :monthly_bucket
end
