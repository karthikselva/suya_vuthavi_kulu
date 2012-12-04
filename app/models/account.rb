class Account < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :accountable, :polymorphic => true
end
