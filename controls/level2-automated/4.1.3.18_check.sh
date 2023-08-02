#!/bin/bash

# Function to check on-disk configuration rules for usermod command
check_on_disk_usermod_rules() {
    local usermod_rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    # Check on-disk rules for usermod command
    usermod_rules=$(awk "/^ *-a *always,exit/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -F *perm=x/ \
    &&/ -F *path=\/usr\/sbin\/usermod/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    # Check if usermod_rules is not empty
    if [ -n "$usermod_rules" ]; then
        echo -e "\n4.1.3.18 Ensure successful and unsuccessful attempts to use the usermod command are recorded --> \e[32mpassed\e[0m\n"
        echo -e "On-disk configuration:\n$usermod_rules\n"
    else
        echo -e "\n4.1.3.18 Ensure successful and unsuccessful attempts to use the usermod command are recorded --> \e[31mfailed\e[0m\n"
        echo -e "Reason: The audit rule for usermod command is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for usermod command
check_on_disk_usermod_rules

# Check loaded rules for usermod command
echo "Running configuration:"
loaded_usermod_rules=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -F *perm=x/ \
&&/ -F *path=\/usr\/sbin\/usermod/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")
if [ -n "$loaded_usermod_rules" ]; then
    echo "$loaded_usermod_rules"
fi
