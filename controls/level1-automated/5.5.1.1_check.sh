#!/bin/bash

# Function to check minimum days between password changes for a specific user
check_user_min_days() {
    local user="$1"
    local min_days=$(grep "^$user:[^!*]" /etc/shadow | awk -F: '{print $4}')

    if [ "$min_days" -ge 1 ]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\033[0;31mfailed\033[0m"
    fi
}

# Function to check all users for minimum days between password changes
check_all_users_min_days() {
    local all_pass=true
    while IFS=: read -r user _ _ _ min_days _; do
        if [ "$min_days" -lt 1 ]; then
            all_pass=false
            break
        fi
    done < /etc/shadow

    if [ "$all_pass" == "true" ]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\033[0;31mfailed\033[0m"
    fi
}

# Check PASS_MIN_DAYS value in /etc/login.defs
pass_min_days_value=$(grep '^\s*PASS_MIN_DAYS\s' /etc/login.defs | awk '{print $2}')
if [ "$pass_min_days_value" -ge 1 ]; then
    result="\033[0;32mpassed\033[0m"
else
    result="\e[31mfailed\e[0m"
fi

# Check each user's minimum days between password changes
awk -F : '(/^[^:]+:[^!*]/ && $4 < 1){print $1}' /etc/shadow | while read -r user; do
    if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
        result=$(check_user_min_days "$user")
    else
        break
    fi
done

# Check all users for minimum days between password changes
if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
    result=$(check_all_users_min_days)
fi

# Print the final result
echo -e "5.5.1.1 Ensure minimum days between password changes is configured --> $result"
