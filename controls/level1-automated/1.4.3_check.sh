#!/bin/bash

# Function to check if authentication is required for single-user mode
check_single_user_mode_auth() {
    local single_user_mode_auth_file="/etc/sysconfig/init"

    # Check if the single user mode auth file exists
    if [ -e "$single_user_mode_auth_file" ]; then
        # Check the content of the single user mode auth file for sulogin
        if grep -Eq 'SINGLE=/sbin/sulogin' "$single_user_mode_auth_file"; then
            echo -e "1.4.3 Ensure authentication required for single user mode --> \033[0;32mpass\033[0m"
        else
            echo -e "1.4.3 Ensure authentication required for single user mode --> \033[0;31mfail\033[0m (Authentication not required)"
        fi
    else
        echo -e "1.4.3 Ensure authentication required for single user mode --> \033[0;31mfail\033[0m (Single user mode auth file not found)"
    fi
}

# Call the function to check if authentication is required for single-user mode
check_single_user_mode_auth
