#!/usr/bin/env bash

# Function to check rsyslog default file permissions
check_rsyslog_default_file_permissions() {
    local file_create_mode=$(grep -E "^\$FileCreateMode\s+" /etc/rsyslog.conf /etc/rsyslog.d/*.conf | awk '{print $2}')

    if [ "$file_create_mode" = "0640" ]; then
        echo -e "\n4.2.2.4 Ensure rsyslog default file permissions are configured --> \e[32mPASS\e[0m"
    else
        echo -e "\n4.2.2.4 Ensure rsyslog default file permissions are configured --> \e[31mFAIL\e[0m"
        echo -e "Current file create mode: $file_create_mode\n"
    fi
}

# Call the function to check rsyslog default file permissions
check_rsyslog_default_file_permissions
