#!/bin/bash

# Function to check if /var/log is on a separate partition
check_separate_partition_varlog() {
    varlog_mount_info=$(df --output=target | grep '/var/log$')
    if [ -z "$varlog_mount_info" ]; then
        echo -e "1.1.5.1 Ensure separate partition exists for /var/log --> \033[0;31mfailed\033[0m"
    else
        echo -e "1.1.5.1 Ensure separate partition exists for /var/log --> \033[0;32mpassed\033[0m"
    fi
}

# Call the function to check if /var/log is on a separate partition
check_separate_partition_varlog
