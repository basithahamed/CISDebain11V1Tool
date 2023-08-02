#!/usr/bin/env bash

# Function to check if SSH warning banner is configured
check_ssh_warning_banner_configured() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "banner")

    if echo "$sshd_output" | grep -qi "banner\s+/etc/issue.net"; then
        echo -e "\n5.2.17 Ensure SSH warning banner is configured --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.17 Ensure SSH warning banner is configured --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH warning banner is configured
check_ssh_warning_banner_configured
