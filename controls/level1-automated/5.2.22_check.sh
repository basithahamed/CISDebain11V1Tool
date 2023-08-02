#!/usr/bin/env bash

# Function to check if SSH Idle Timeout Interval is configured
check_ssh_idle_timeout() {
    sshd_interval=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientaliveinterval)
    sshd_count_max=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep clientalivecountmax)

    interval=$(echo "$sshd_interval" | awk '{print $2}')
    count_max=$(echo "$sshd_count_max" | awk '{print $2}')

    if [ "$interval" -gt 0 ] && [ "$count_max" -gt 0 ]; then
        echo -e "\n5.2.22 Ensure SSH Idle Timeout Interval is configured --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.22 Ensure SSH Idle Timeout Interval is configured --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH Idle Timeout Interval is configured
check_ssh_idle_timeout
