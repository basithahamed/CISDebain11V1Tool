#!/bin/bash

# Function to check if nosuid option is set on /var/log/audit partition
check_nosuid_var_log_audit() {
    if [ -d "/var/log/audit" ]; then
        mount_options=$(grep -E "^\s*$(df -P /var/log/audit | tail -1 | awk '{print $1}')\s" /proc/mounts | awk '{print $4}')
        if [[ $mount_options == *"nosuid"* ]]; then
            echo -e "1.1.6.4 Ensure nosuid option set on /var/log/audit partition --> \033[0;32mpassed\033[0m"
        else
            echo -e "1.1.6.4 Ensure nosuid option set on /var/log/audit partition --> \033[0;31mfailed\033[0m"
        fi
    else
        echo -e "1.1.6.4 Ensure nosuid option set on /var/log/audit partition --> \033[0;31mfailed\033[0m (Directory not found)"
    fi
}

# Call the function to check if nosuid option is set on /var/log/audit partition
check_nosuid_var_log_audit
