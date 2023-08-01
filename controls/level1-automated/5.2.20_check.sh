#!/usr/bin/env bash

# Function to check if SSH MaxSessions is set to 10 or less
check_ssh_max_sessions() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxsessions)
    sshd_config_output=$(grep -Ei '^\s*MaxSessions\s+(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)' /etc/ssh/sshd_config)

    if echo "$sshd_output" | grep -qi "maxsessions 10" && [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.20 Ensure SSH MaxSessions is set to 10 or less --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.2.20 Ensure SSH MaxSessions is set to 10 or less --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if SSH MaxSessions is set to 10 or less
check_ssh_max_sessions
