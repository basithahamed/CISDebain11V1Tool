#!/bin/bash

# Function to check if sudo authentication timeout is configured correctly
check_sudo_timeout() {
    local timeout=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers* | head -1)
    local default_timeout=15

    if [ -z "$timeout" ]; then
        timeout=$(sudo -V | grep "Authentication timestamp timeout:" | grep -oP "[0-9]+")
        if [ -z "$timeout" ]; then
            timeout=$default_timeout
        fi
    fi

    if [ "$timeout" -eq -1 ]; then
        echo -e "\n5.3.6 Ensure sudo authentication timeout is configured correctly --> \033[0;31mFail\033[0m (Timeout is disabled)"
    elif [ "$timeout" -le 0 ] || [ "$timeout" -gt 15 ]; then
        echo -e "\n5.3.6 Ensure sudo authentication timeout is configured correctly --> \033[0;31mFail\033[0m (Timeout is set to $timeout minutes)"
    else
        echo -e "\n5.3.6 Ensure sudo authentication timeout is configured correctly --> \033[0;32mPass\033[0m (Timeout is set to $timeout minutes)"
    fi
}

# Call the function to check if sudo authentication timeout is configured correctly
check_sudo_timeout
