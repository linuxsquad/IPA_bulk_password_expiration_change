IPA Bulk Password Expiration Change
=========================

The script detects IPA user accounts with expiring password and changes expiration to a future date.

The script takes the following inline options: 
--------------------

* -E|e [YYYYMMDD]   A new [E]xpiration date, this must be provided if -M option used.   
* -M                [M]odify the expiration date; if ommitted, script just shows the affected users.
* -T|t "string"     String argument used to [T]est when current user passwords expiring, for instance `"next week"`, `"tomorrow"`, `"next month"`, etc. If ommitted, the script will use `"next week"`.                                                               

How to customize the script for your environement
--------------------

Couple things have to be changed to adopt this script to your enviroment. 

1. File `./password` has to contain a password for LDAP `"Directory Manager"`. 
1. File `./modify.ldif` has to be updated with your company/business/org Domain name (`dc=example,dc=com`). Don't change anything else, since it may criple the processing.
 
``` shell
 dn: uid=%%USER%%,cn=users,cn=accounts,dc=example,dc=com
 changetype: modify
 replace: krbpasswordexpiration
 krbPasswordExpiration: %%EXPIRATIONDATE%%
```

Here are couple examples:
--------------  
  
1.  Find out all users whos password expires next week: 
``` shell 
 ./modifyExpDate.sh -t "next week"
```  
1. Update expiration date to [Oct-01-2020] for all users whos password expires next month:
``` shell
 ./modifyExpDate.sh -t "next month" -M -e "20201001" 
```   
   
   
