#!/bin/bash

# Function to check if an account has a shadowed password
check_shadowed_password() {
    local user="$1"
    local password_field=$(grep "^$user:" /etc/passwd | awk -F: '{print $2}')

    if [ "$password_field" != "x" ]; then
        echo -n -e "\e[31mFAIL\e[0m"
    else
        echo -n -e "\e[32mPASS\e[0m"
    fi
}

# Initialize a variable to track the overall result
overall_result="PASS"

# Check each user in /etc/passwd for shadowed passwords
while IFS=: read -r user _; do
    result=$(check_shadowed_password "$user")
    if [ "$result" == "FAIL" ]; then
        overall_result="FAIL"
    fi
done < /etc/passwd

# Print the final result with color
if [ "$overall_result" == "PASS" ]; then
    echo -e "6.2.1 Ensure accounts in /etc/passwd use shadowed passwords --> \e[32m$overall_result\e[0m"
else
    echo -e "6.2.1 Ensure accounts in /etc/passwd use shadowed passwords --> \e[31m$overall_result\e[0m"
fi
