#!/usr/bin/env bash

# Function to check if SSH MaxAuthTries is set to 4 or less
check_ssh_max_auth_tries() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep maxauthtries)

    if echo "$sshd_output" | grep -qi "maxauthtries\s+4"; then
        echo -e "\n5.2.18 Ensure SSH MaxAuthTries is set to 4 or less --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.2.18 Ensure SSH MaxAuthTries is set to 4 or less --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if SSH MaxAuthTries is set to 4 or less
check_ssh_max_auth_tries
