#!/bin/bash

# Function to check if nosuid option is set on /var/log partition
check_nosuid_varlog() {
    varlog_mount_options=$(mount | grep 'on /var/log ' | awk '{print $6}')
    if [[ "$varlog_mount_options" == *"nosuid"* ]]; then
        echo -e "1.1.5.4 Ensure nosuid option set on /var/log partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.5.4 Ensure nosuid option set on /var/log partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if nosuid option is set on /var/log partition
check_nosuid_varlog
