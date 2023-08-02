#!/bin/bash

# Function to check on-disk configuration rules for setfacl command
check_on_disk_setfacl_rules() {
    local setfacl_rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    # Check on-disk rules for setfacl command
    setfacl_rules=$(awk "/^ *-a *always,exit/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -F *perm=x/ \
    &&/ -F *path=\/usr\/bin\/setfacl/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    # Check if setfacl_rules is not empty
    if [ -n "$setfacl_rules" ]; then
        echo -e "\n4.1.3.16 Ensure successful and unsuccessful attempts to use the setfacl command are recorded --> \e[32mpassed\e[0m\n"
        echo -e "On-disk configuration:\n$setfacl_rules\n"
    else
        echo -e "\n4.1.3.16 Ensure successful and unsuccessful attempts to use the setfacl command are recorded --> \e[31mfailed\e[0m\n"
        echo -e "Reason: The audit rule for setfacl command is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for setfacl command
check_on_disk_setfacl_rules

# Check loaded rules for setfacl command
echo "Running configuration:"
loaded_setfacl_rules=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -F *perm=x/ \
&&/ -F *path=\/usr\/bin\/setfacl/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")
if [ -n "$loaded_setfacl_rules" ]; then
    echo "$loaded_setfacl_rules"
fi
