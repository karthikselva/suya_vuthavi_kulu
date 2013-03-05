
EXPENSES_ACC_ID = Account.find_by_name("Expences").id
Int_Percentage = 1

def get_interest(amount, percentage=Int_Percentage)
  amount * percentage / 100
end