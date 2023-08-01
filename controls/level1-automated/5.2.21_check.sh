#!/usr/bin/env bash

# Function to check if SSH LoginGraceTime is set to one minute or less
check_ssh_login_grace_time() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep logingracetime)
    sshd_config_output=$(grep -Ei '^\s*LoginGraceTime\s+(0|6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+|[^1]m)' /etc/ssh/sshd_config)

    if echo "$sshd_output" | grep -qi "logingracetime 60" && [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.21 Ensure SSH LoginGraceTime is set to one minute or less --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.2.21 Ensure SSH LoginGraceTime is set to one minute or less --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if SSH LoginGraceTime is set to one minute or less
check_ssh_login_grace_time
