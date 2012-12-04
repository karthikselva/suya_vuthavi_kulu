class Bank < ActiveRecord::Base
  # attr_accessible :title, :body
  has_one :account, :as => :accountable
end
