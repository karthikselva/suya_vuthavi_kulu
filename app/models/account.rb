class Account < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :accountable , :polymorphic => true 
  has_many :account_transactions 
end
