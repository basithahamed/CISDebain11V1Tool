#!/usr/bin/env bash

# Function to check if SSH PAM is enabled
check_ssh_pam_enabled() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i 'usepam yes')
    sshd_config_output=$(grep -Ei '^\s*UsePAM\s+no' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] || [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.6 Ensure SSH PAM is enabled --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.6 Ensure SSH PAM is enabled --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH PAM is enabled
check_ssh_pam_enabled
