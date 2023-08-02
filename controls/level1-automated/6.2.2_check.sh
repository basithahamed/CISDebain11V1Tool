#!/bin/bash

# Function to check if a password field in /etc/shadow is empty
check_password_not_empty() {
    local user="$1"
    local password_field=$(grep "^$user:" /etc/shadow | awk -F: '{print $2}')

    if [ -z "$password_field" ]; then
        echo -n -e "\e[31mfailed\e[0m"
    else
        echo -n -e "\033[0;32mpassed\033[0m"
    fi
}

# Initialize a variable to track the overall result
overall_result="passed"

# Check each user in /etc/shadow for empty password fields
while IFS=: read -r user _; do
    result=$(check_password_not_empty "$user")
    if [ "$result" == "FAIL" ]; then
        overall_result="FAIL"
    fi
done < /etc/shadow

# Print the final result with color
if [ "$overall_result" == "PASS" ]; then
    echo -e "6.2.2 Ensure /etc/shadow password fields are not empty --> \e[32m$overall_result\e[0m"
else
    echo -e "6.2.2 Ensure /etc/shadow password fields are not empty --> \e[31m$overall_result\e[0m"
fi
