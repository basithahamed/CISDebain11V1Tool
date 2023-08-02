#!/bin/bash

# Function to check password expiration warning days for a specific user
check_user_pass_warn_age() {
    local user="$1"
    local pass_warn_age=$(grep "^$user:[^!*]" /etc/shadow | awk -F: '{print $6}')

    if [ -z "$pass_warn_age" ]; then
        echo -e "\033[0;31mfailed\033[0m"
    elif [ "$pass_warn_age" -ge 7 ]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\033[0;31mfailed\033[0m"
    fi
}

# Function to check all users for password expiration warning days
check_all_users_pass_warn_age() {
    local all_pass=true

    while IFS=: read -r user _ _ _ _ pass_warn_age _; do
        if [ -z "$pass_warn_age" ] || [ "$pass_warn_age" -lt 7 ]; then
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

# Check PASS_WARN_AGE value in /etc/login.defs
pass_warn_age_value=$(grep '^\s*PASS_WARN_AGE\s' /etc/login.defs | awk '{print $2}')
if [ -z "$pass_warn_age_value" ] || [ "$pass_warn_age_value" -ge 7 ]; then
    result="\033[0;32mpassed\033[0m"
else
    result="\033[0;31mfailed\033[0m"
fi

# Check each user's password expiration warning days
awk -F : '(/^[^:]+:[^!*]/ && $6 < 7){print $1}' /etc/shadow | while read -r user; do
    if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
        result=$(check_user_pass_warn_age "$user")
    else
        break
    fi
done

# Check all users for password expiration warning days
if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
    result=$(check_all_users_pass_warn_age)
fi

# Print the final result
echo -e "5.5.1.3 Ensure password expiration warning days is 7 or more --> $result"
