#!/usr/bin/env bash

# Function to check if SSH PermitEmptyPasswords is disabled
check_ssh_permit_empty_passwords_disabled() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i 'permitemptypasswords no')
    sshd_config_output=$(grep -Ei '^\s*PermitEmptyPasswords\s+yes' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] && [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.9 Ensure SSH PermitEmptyPasswords is disabled --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.2.9 Ensure SSH PermitEmptyPasswords is disabled --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if SSH PermitEmptyPasswords is disabled
check_ssh_permit_empty_passwords_disabled
