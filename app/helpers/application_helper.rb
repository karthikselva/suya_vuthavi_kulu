module ApplicationHelper
 
 def get_interest(amount, percentage=1)
   amount * percentage / 100
 end

end
