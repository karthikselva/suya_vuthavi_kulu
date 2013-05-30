exp_acc = Account.find_by_name("Expences")
EXPENSES_ACC_ID = exp_acc ? exp_acc.id : nil

Int_Percentage = 1

def get_interest(amount, percentage=Int_Percentage)
  (amount * percentage / 100) + ((amount % 100) >= 50 ? 1 : 0)
end