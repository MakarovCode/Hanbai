
set :output, "log/whenever.log"

#Bogotá/America -5 UTC
every 1.day, :at => '8:00 am' do
  runner "Activity.daily(1)"
end

every 1.day, :at => '8:00 pm' do
  runner "Activity.daily(2)"
end

every 1.day, :at => '6:00 pm' do
  runner "User.accounts_expiring(5)"
  runner "User.accounts_expired"
end

# every 15.minutes do
#   #runner "Activity.just_before_activity"
# end

every 15.minutes do
  runner "Activity.check_overdue"
end
