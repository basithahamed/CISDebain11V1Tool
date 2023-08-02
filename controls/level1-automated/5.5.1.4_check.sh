#!/bin/bash

# Function to check inactive password lock for a specific user
check_user_inactive() {
    local user="$1"
    local inactive=$(grep "^$user:[^!*]" /etc/shadow | awk -F: '{print $7}')

    if [[ "$inactive" =~ ^([0-9]+|-1)$ && "$inactive" -le 30 ]]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\033[0;31mfailed\033[0m"
    fi
}

# Function to check all users for inactive password lock
check_all_users_inactive() {
    local all_pass=true

    while IFS=: read -r user _ _ _ _ _ inactive _; do
        if ! [[ "$inactive" =~ ^([0-9]+|-1)$ && "$inactive" -le 30 ]]; then
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

# Check INACTIVE value using useradd command
inactive_value=$(useradd -D | grep 'INACTIVE' | awk -F= '{print $2}')
if [[ "$inactive_value" =~ ^([0-9]+|-1)$ && "$inactive_value" -le 30 ]]; then
    result="\033[0;32mpassed\033[0m"
else
    result="\033[0;31mfailed\033[0m"
fi

# Check each user's inactive password lock
awk -F : '(/^[^:]+:[^!*]/ && ($7~/(\\s*$|-1)/ || $7>30)){print $1}' /etc/shadow | while read -r user; do
    if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
        result=$(check_user_inactive "$user")
    else
        break
    fi
done

# Check all users for inactive password lock
if [ "$result" == "\033[0;32mpassed\033[0m" ]; then
    result=$(check_all_users_inactive)
fi

# Print the final result
echo -e "5.5.1.4 Ensure inactive password lock is 30 days or less --> $result"
