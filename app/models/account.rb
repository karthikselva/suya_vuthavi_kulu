class Account < ActiveRecord::Base

  attr_accessible :name, :accountable_id, :accountable_type,:outstanding_balance
  belongs_to :accountable, :polymorphic => true

  def self.make_account(obj)
  	account = obj.account
  	name = {"Group" => "name", "Bank" => "account_name", "User" => "full_name"}[obj.class.to_s]
  	if account
  	  account.update_attributes(:name => obj.send(name))	
  	else
  	  account = self.new(:name => obj.send(name), :accountable_id => obj.id, :accountable_type => obj.class.to_s)	
      account.save
  	end
  end	

end
