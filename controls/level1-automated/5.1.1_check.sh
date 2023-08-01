#!/usr/bin/env bash

# Function to check if cron daemon is enabled and running
check_cron_status() {
    local cron_enabled=$(systemctl is-enabled cron 2>&1)
    local cron_running=$(systemctl is-active cron 2>&1)

    if [[ "$cron_enabled" == "enabled" && "$cron_running" == "active" ]]; then
        echo -e "\e[32mPASS\e[0m"
    else
        echo -e "\e[31mFAIL\e[0m"
    fi
}

# Call the function to check if cron daemon is enabled and running
result=$(check_cron_status)
echo "\n5.1.1 Ensure cron daemon is enabled and running --> $result"
