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

  def monthly_decision_book(tran_date, to_account_id)
    from_date = tran_date.to_date.beginning_of_month
    to_date = tran_date.to_date.end_of_month
    atds = AccountTranDetail.where(["from_account_id = ? and to_account_id = ? and transaction_date >= ? and transaction_date <= ? and (saving != 0 or due != 0 or other_amount != 0 or principle_credit != 0 or interest_credit != 0)",self.id, to_account_id, from_date, to_date])
    ac = {"saving" => 0, "due" => 0, "principle_credit" => 0, "interest_credit" => 0, "other_amount" => 0}
    return atds.inject(ac){|acc,val|
      acc["saving"] = acc["saving"].to_f + val.saving.to_f
      acc["due"] = acc["due"].to_f + val.due.to_f
      acc["principle_credit"] = acc["principle_credit"].to_f + val.principle_credit.to_f
      acc["interest_credit"] = acc["interest_credit"].to_f + val.interest_credit.to_f
      acc["other_amount"] = acc["other_amount"].to_f + val.other_amount.to_f
      acc
    }
  end

  def monthly_decision_book_debit(tran_date, to_account_id)
    from_date = tran_date.to_date.beginning_of_month
    to_date = tran_date.to_date.end_of_month
    atds = AccountTranDetail.where(["from_account_id = ? and to_account_id = ? and transaction_date >= ? and transaction_date <= ? and (principle_debit != 0)", to_account_id, self.id, from_date, to_date])
    ac = {"principle_debit" => 0}
    return atds.inject(ac){|acc,val|
      acc["principle_debit"] = acc["principle_debit"].to_f + val.principle_debit.to_f
      acc
    }
  end

  def last_month_outstanding_Principal(date, to_account_id)
    tran_date = date.beginning_of_month - 1
    from_date = tran_date.to_date.beginning_of_month
    to_date = tran_date.to_date.end_of_month
    atd = AccountTranDetail.where(["((from_account_id = ? and to_account_id = ? and principle_credit != 0) or (from_account_id = ? and to_account_id = ? and principle_debit != 0)) and transaction_date >= ? and transaction_date <= ? ",self.id, to_account_id, to_account_id, self.id, from_date, to_date]).order("id desc").first
    atd ? (atd.principle_credit.to_f > 0 ? atd.to_outs_balance : atd.from_outs_balance) : 0
  end

end
