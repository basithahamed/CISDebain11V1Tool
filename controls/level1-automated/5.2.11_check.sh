#!/usr/bin/env bash

# Function to check if SSH IgnoreRhosts is enabled
check_ssh_ignore_rhosts_enabled() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i 'ignorerhosts yes')
    sshd_config_output=$(grep -Ei '^\s*IgnoreRhosts\s+no\b' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] && [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.11 Ensure SSH IgnoreRhosts is enabled --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.2.11 Ensure SSH IgnoreRhosts is enabled --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if SSH IgnoreRhosts is enabled
check_ssh_ignore_rhosts_enabled
