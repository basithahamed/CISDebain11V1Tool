#!/usr/bin/env bash

# Function to check if SSH LogLevel is appropriate
check_ssh_loglevel() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -Ei 'loglevel (VERBOSE|INFO)')
    sshd_config_output=$(grep -Ei '^\s*LogLevel\s+(VERBOSE|INFO)' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] || [ -n "$sshd_config_output" ]; then
        echo -e "\n5.2.5 Ensure SSH LogLevel is appropriate --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.5 Ensure SSH LogLevel is appropriate --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH LogLevel is appropriate
check_ssh_loglevel
