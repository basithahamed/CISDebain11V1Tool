#!/usr/bin/env bash

# Function to check if SSH root login is disabled
check_ssh_root_login_disabled() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i 'permitrootlogin no')
    sshd_config_output=$(grep -Ei '^\s*PermitRootLogin\s+no' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] && [ -n "$sshd_config_output" ]; then
        echo -e "\n5.2.7 Ensure SSH root login is disabled --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.2.7 Ensure SSH root login is disabled --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if SSH root login is disabled
check_ssh_root_login_disabled
