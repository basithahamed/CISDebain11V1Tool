#!/bin/bash

# Function to check if the apparmor_status command is available
check_apparmor_command() {
    if ! command -v apparmor_status &> /dev/null; then
        echo -e "1.6.1.4 Ensure all AppArmor Profiles are enforcing --> \033[0;31mfailed\033[0m (AppArmor not installed)"
        exit 1
    fi
}

# Function to check if all AppArmor profiles are enforcing
check_apparmor_profiles_enforcing() {
    local apparmor_status_output=$(apparmor_status)

    # Check if the profiles are loaded and in enforce mode
    if echo "$apparmor_status_output" | grep -q "profiles are loaded" && \
       echo "$apparmor_status_output" | grep -q "profiles are in enforce mode" && \
       echo "$apparmor_status_output" | grep -q "0 profiles are in complain mode"; then
        echo -e "1.6.1.4 Ensure all AppArmor Profiles are enforcing --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.6.1.4 Ensure all AppArmor Profiles are enforcing --> \033[0;31mfailed\033[0m"
    fi

    # Check if no processes are unconfined
    if echo "$apparmor_status_output" | grep -q "0 processes are unconfined but have a profile defined"; then
        echo -e "1.6.1.4 Ensure all processes are confined by AppArmor --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.6.1.4 Ensure all processes are confined by AppArmor --> \033[0;31mfailed\033[0m"
    fi
}

# Check if the apparmor_status command exists
check_apparmor_command

# Call the function to check if all AppArmor profiles are enforcing
check_apparmor_profiles_enforcing
