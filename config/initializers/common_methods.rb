# a = Account.find_by_name("Expences")
EXPENSES_ACC_ID = 1 #a ? a.id : nil
Int_Percentage = 1

def get_interest(amount, percentage=Int_Percentage)
  amount * percentage / 100
end