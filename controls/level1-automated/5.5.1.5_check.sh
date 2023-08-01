#!/bin/bash

# Function to check last password change date for a specific user
check_user_last_password_change() {
    local user="$1"
    local last_change=$(date -d "$(chage --list "$user" | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s)

    if [[ "$last_change" -gt "$(date +%s)" ]]; then
        echo -e "\033[0;31mUser: \"$user\" last password change was \"$(chage --list "$user" | grep '^Last password change' | cut -d: -f2)\"\033[0m"
        return 1  # Return failure status
    fi
    return 0  # Return success status
}

# Check last password change date for all users
awk -F: '(/^[^:]+:[^!*]/){print $1}' /etc/shadow | while read -r user; do
    check_user_last_password_change "$user"
done

# Print the final result
if [ $? -eq 0 ]; then
    echo -e "5.5.1.5 Ensure all users last password change date is in the past --> \033[0;32mPASS\033[0m"
else
    echo -e "5.5.1.5 Ensure all users last password change date is in the past --> \033[0;31mFAIL\033[0m"
fi
