#!/bin/bash

# Function to check on-disk configuration rules for chacl command
check_on_disk_chacl_rules() {
    local chacl_rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    # Check on-disk rules for chacl command
    chacl_rules=$(awk "/^ *-a *always,exit/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -F *perm=x/ \
    &&/ -F *path=\/usr\/bin\/chacl/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    # Check if chacl_rules is not empty
    if [ -n "$chacl_rules" ]; then
        echo -e "\n4.1.3.17 Ensure successful and unsuccessful attempts to use the chacl command are recorded --> \e[32mPass\e[0m\n"
        echo -e "On-disk configuration:\n$chacl_rules\n"
    else
        echo -e "\n4.1.3.17 Ensure successful and unsuccessful attempts to use the chacl command are recorded --> \e[31mFail\e[0m\n"
        echo -e "Reason: The audit rule for chacl command is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for chacl command
check_on_disk_chacl_rules

# Check loaded rules for chacl command
echo "Running configuration:"
loaded_chacl_rules=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -F *perm=x/ \
&&/ -F *path=\/usr\/bin\/chacl/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")
if [ -n "$loaded_chacl_rules" ]; then
    echo "$loaded_chacl_rules"
fi
