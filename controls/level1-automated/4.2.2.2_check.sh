#!/usr/bin/env bash

# Function to check if rsyslog service is enabled
check_rsyslog_service_enabled() {
    local service_status=$(systemctl is-enabled rsyslog)

    if [ "$service_status" = "enabled" ]; then
        echo -e "\n4.2.2.2 Ensure rsyslog service is enabled --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n4.2.2.2 Ensure rsyslog service is enabled --> \e[31mfailed\e[0m"
        echo -e "Service status: $service_status\n"
    fi
}

# Call the function to check if rsyslog service is enabled
check_rsyslog_service_enabled
