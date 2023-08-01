#!/usr/bin/env bash

# Function to check if journald is configured to send logs to rsyslog
check_journald_forward_to_rsyslog() {
    local config_status=$(grep -E "^\s*ForwardToSyslog\s*=\s*yes" /etc/systemd/journald.conf)

    if [ -n "$config_status" ]; then
        echo -e "\n4.2.2.3 Ensure journald is configured to send logs to rsyslog --> \e[32mPASS\e[0m"
    else
        echo -e "\n4.2.2.3 Ensure journald is configured to send logs to rsyslog --> \e[31mFAIL\e[0m"
        echo -e "Current configuration status: $config_status\n"
    fi
}

# Call the function to check if journald is configured to send logs to rsyslog
check_journald_forward_to_rsyslog
