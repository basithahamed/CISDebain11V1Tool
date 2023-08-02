#!/bin/bash

# Function to check password expiration for a specific user
check_user_pass_max_days() {
    local user="$1"
    local pass_max_days=$(grep "^$user:[^!*]" /etc/shadow | awk -F: '{print $5}')

    if [[ $pass_max_days -le 365 && $pass_max_days -gt $(grep '^\s*PASS_MIN_DAYS\s' /etc/login.defs | awk '{print $2}') ]]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\033[0;31mfailed\033[0m"
    fi
}

# Function to check all users for password expiration
check_all_users_pass_max_days() {
    local all_pass=true
    local pass_min_days=$(grep '^\s*PASS_MIN_DAYS\s' /etc/login.defs | awk '{print $2}')

    while IFS=: read -r user _ _ _ pass_max_days _; do
        if [[ $pass_max_days -gt 365 || $pass_max_days -le $pass_min_days ]]; then
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

# Check PASS_MAX_DAYS value in /etc/login.defs
pass_max_days_value=$(grep '^\s*PASS_MAX_DAYS\s' /etc/login.defs | awk '{print $2}')
if [[ $pass_max_days_value -le 365 && $pass_max_days_value -gt $(grep '^\s*PASS_MIN_DAYS\s' /etc/login.defs | awk '{print $2}') ]]; then
    result="\033[0;32mpassed\033[0m"
else
    result="\033[0;31mfailed\033[0m"
fi

# Check each user's password expiration
awk -F : '(/^[^:]+:[^!*]/ && ($5>365 || $5~/([0-1]|-1|\s*)/)){print $1}' /etc/shadow | while read -r user; do
    if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
        result=$(check_user_pass_max_days "$user")
    else
        break
    fi
done

# Check all users for password expiration
if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
    result=$(check_all_users_pass_max_days)
fi

# Print the final result
echo -e "5.5.1.2 Ensure password expiration is 365 days or less --> $result"
