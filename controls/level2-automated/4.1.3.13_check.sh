#!/bin/bash

# Function to check on-disk configuration rules for file deletion events by users
check_on_disk_file_deletion_rules() {
    local file_deletion_rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    # Check on-disk rules for file deletion events by users
    file_deletion_rules=$(awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -S/ \
    &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    # Check if file_deletion_rules is not empty
    if [ -n "$file_deletion_rules" ]; then
        echo -e "\n4.1.3.13 Ensure file deletion events by users are collected --> \e[32mpassed\e[0m\n"
        echo -e "On-disk configuration:\n$file_deletion_rules\n"
    else
        echo -e "\n4.1.3.13 Ensure file deletion events by users are collected --> \e[31mfailed\e[0m\n"
        echo -e "Reason: The audit rule for file deletion events by users is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for file deletion events by users
check_on_disk_file_deletion_rules

# Check loaded rules for file deletion events by users
echo "Running configuration:"
loaded_file_deletion_rules=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -S/ \
&&(/unlink/||/rename/||/unlinkat/||/renameat/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")
if [ -n "$loaded_file_deletion_rules" ]; then
    echo "$loaded_file_deletion_rules"
fi
