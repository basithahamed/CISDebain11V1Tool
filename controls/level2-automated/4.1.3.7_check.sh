#!/bin/bash

# Function to check unsuccessful file access attempts are collected
check_unsuccessful_file_access_attempts() {
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -z "$UID_MIN" ]; then
        echo "ERROR: Variable 'UID_MIN' is unset."
        exit 1
    fi

    local output=""
    local found=0
    for RULE_FILE in /etc/audit/rules.d/*.rules; do
        if grep -q -E '^-a *always,exit *-F *arch=b[2346]{2} *(-F *auid!=unset|-F *auid!=-1|-F *auid!=4294967295) *-F *auid>='"$UID_MIN"' *-F *exit=-(EACCES|EPERM) *-S *(creat|open|openat|truncate|ftruncate) *(-F *path=|-F *dir=)' "$RULE_FILE"; then
            output+="$(grep -E '^-a *always,exit *-F *arch=b[2346]{2} *(-F *auid!=unset|-F *auid!=-1|-F *auid!=4294967295) *-F *auid>='"$UID_MIN"' *-F *exit=-(EACCES|EPERM) *-S *(creat|open|openat|truncate|ftruncate) *(-F *path=|-F *dir=)' "$RULE_FILE")\n"
            found=1
        fi
    done

    if [ $found -eq 1 ]; then
        echo -e "\n4.1.3.7 Ensure unsuccessful file access attempts are collected - \e[32mpassed\e[0m"
        echo -e "Verify the output includes:\n$output"
    else
        echo -e "\n4.1.3.7 Ensure unsuccessful file access attempts are collected - \e[31mfailed\e[0m"
        echo "No matching rules found in audit rules."
    fi
}

# Call the function to check unsuccessful file access attempts are collected
check_unsuccessful_file_access_attempts
