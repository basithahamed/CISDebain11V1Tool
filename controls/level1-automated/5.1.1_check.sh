#!/usr/bin/env bash

# Function to check if cron daemon is enabled and running
check_cron_status() {
    local cron_enabled=$(systemctl is-enabled cron 2>&1)
    local cron_running=$(systemctl is-active cron 2>&1)

    if [[ "$cron_enabled" == "enabled" && "$cron_running" == "active" ]]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\e[31mfailed\e[0m"
    fi
}

# Call the function to check if cron daemon is enabled and running
result=$(check_cron_status 2>/dev/null)  # Redirect stderr to /dev/null to suppress the error messages
echo -e "\n5.1.1 Ensure cron daemon is enabled and running --> $result"
