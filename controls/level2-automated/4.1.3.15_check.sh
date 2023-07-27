#!/bin/bash

# Function to check on-disk configuration rules for chcon command
check_on_disk_chcon_rules() {
    local chcon_rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    # Check on-disk rules for chcon command
    chcon_rules=$(awk "/^ *-a *always,exit/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -F *perm=x/ \
    &&/ -F *path=\/usr\/bin\/chcon/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    # Check if chcon_rules is not empty
    if [ -n "$chcon_rules" ]; then
        echo -e "\n4.1.3.15 Ensure successful and unsuccessful attempts to use the chcon command are recorded --> \e[32mPass\e[0m\n"
        echo -e "On-disk configuration:\n$chcon_rules\n"
    else
        echo -e "\n4.1.3.15 Ensure successful and unsuccessful attempts to use the chcon command are recorded --> \e[31mFail\e[0m\n"
        echo -e "Reason: The audit rule for chcon command is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for chcon command
check_on_disk_chcon_rules

# Check loaded rules for chcon command
echo "Running configuration:"
loaded_chcon_rules=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -F *perm=x/ \
&&/ -F *path=\/usr\/bin\/chcon/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")
if [ -n "$loaded_chcon_rules" ]; then
    echo "$loaded_chcon_rules"
fi
