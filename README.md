# IPA_bulk_password_expiration_change
The script detects user accounts with expiring password and changes expiration to a future date.

Here is one more script (Im sure there are 100s similar ones) for changing IPA user password expiration date in bulk. 

Your first step is to find out how many users have password expiring in next week. You can supply any string that is parsed by [date] command (for instance, "tomorrow", "next month", "next friday", etc)

modifyExpUser.sh -d "next week" 

Once you confirm the affected users, add -M to actually modify the date. 

modifyExpUser.sh -d "next week" -M 



