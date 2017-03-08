IPA Bulk Password Expiration Change
=========================

The script detects IPA user accounts with expiring password and changes expiration to a future date.

The script takes the following inline options: 
--------------------
 * -E|e [YYYYMMDD]   A new [E]xpiration date, this must be provided if -M option used.   
 * -M                [M]odify the expiration date; if ommitted, script just shows the affected users.
 * -T|t "string"     String argument used to [T]est when current user passwords expiring, for instance "next week", "tomorrow", "next month", etc. If ommitted, using "next week"                                                               


Here are couple examples:
--------------  
  
1.  Find out all users whos password expires next week: 
> ./modifyExpDate.sh -t "next week"
     
1. Update expiration date to [Oct-01-2020] for all users whos password expires next month:
> ./modifyExpDate.sh -t "next month" -M -e "20201001" 
   
   
   
