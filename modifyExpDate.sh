#!/bin/bash 
#
# AUTHOR: linuxsquad
#
# DATE:   2017-03-07
#
# DESCRIPTION:  changing user password expiration day in bulk
#
# PRE-REQUISIT: Gain admin privileges prior to running the script (kinit <admin>)
#
# INPUT:   -E|e [YYYYMMDD] A new [E]xpiration date, this must be provided if -M option used.
#          -M [M]odify the expiration date; if ommitted, script just shows the affected users. 
#          -T|t "string" String argument used to [T]est when current user passwords expiring, for instance "next week", "tomorrow", "next month", etc. If ommitted, using "next week"
#
# OUTPUT:    list of affected users
#
# RELEASE NOTE: 1.0
#               1.1 Command line option for entering a new expiration date
#
# USAGE EXAMPLE: 
# 1- Find out all users whos password expires next week:
#
# ./modifyExpDate.sh -t "next week"
#
# 2- Update expiration date to [Oct-01-2020] for all users whos password expires next month:
#
# ./modifyExpDate.sh -t "next month" -M -e "20201001"

typeset TEMPLATE="./modify.ldif"
typeset NEWEXPDATEADD="230101Z"
typeset PASSFILE="./password"
t_string="next week"      

while getopts "Mt:T:e:E:" opt
do
    case "${opt}" in
	M)  actionFlag="MDF"
	        ;;
	t|T) t_string=${OPTARG}      
	    ;;
	e|E) t_expdate=${OPTARG}
	    ;;
	\?)
	    echo "  ERR01: Invalid option: -${OPTARG}"
	    exit 1
	    ;;
    esac
done

if [ "X"${actionFlag} == "XMDF" ] && 
	[[ $(/bin/date  +%Y%m%d ) -gt ${t_expdate} ]]
then
    echo "  ERR02: A new expiration date has to be in a future. Use the following format: [YYYYMMDD]"
    exit 1
fi 

typeset  TESTDATE=$(/bin/date -d "${t_string}" +%Y%m%d)
typeset  NEWEXPDATE=${t_expdate}"${NEWEXPDATEADD}"
echo  "The following user passwords are expiring prior to the "${TESTDATE}" and will be changed to "${t_expdate:-"[NON SUPPLIED]"}    

sleep 5

ipa user-find | grep User\ login | cut -d":" -f2 | while read user
do  
    # extract password expiration date
    expdate=$( ldapsearch -x -h localhost -p 389 -vv uid=$user 2>&1 | grep Expira | sed -E -e 's/^.*\: //' -e 's/[0-9]{6}Z//' )

    # if password expiration is within time interval
    if [[ ${expdate} < ${TESTDATE} ]]
    then
	echo -e ${expdate}"\t"${user}
	if [ "X"${actionFlag} == "XMDF" ]
	then
	    sed -e "s/\%\%USER\%\%/$user/" -e "s/\%\%EXPIRATIONDATE\%\%/${NEWEXPDATE}/" ${TEMPLATE} > ${TEMPLATE}"."${user} 
            ldapmodify -x -h localhost -D "cn=Directory Manager" -y ${PASSFILE} -f ${TEMPLATE}"."${user}
	fi
    fi
    wait
done 

