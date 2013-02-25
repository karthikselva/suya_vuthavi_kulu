require 'rubygems'
require 'rufus/scheduler'  

scheduler = Rufus::Scheduler.start_new

# Run once a month at midnight in the morning of the first of the month
scheduler.cron("0 0 1 * *") do
  Group.update_final_balance(Date.today - 1)
end

scheduler.cron("0 0 1 * *") do
  Bank.update_bank_final_balance(Date.today - 1)
end

