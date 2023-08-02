#!/usr/bin/env bash

# Function to check if SSH access is limited
check_ssh_access_limit() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$')
    sshd_config_output=$(grep -Pi '^\h*(allow|deny)(users|groups)\h+\H+(\h+.*)?$' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] || [ -n "$sshd_config_output" ]; then
        echo -e "\n5.2.4 Ensure SSH access is limited --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.4 Ensure SSH access is limited --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH access is limited
check_ssh_access_limit
