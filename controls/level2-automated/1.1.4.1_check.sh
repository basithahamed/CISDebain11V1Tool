#!/bin/bash

# Function to check if a separate partition exists for /var/tmp
check_separate_partition_vartmp() {
    vartmp_mount_info=$(mount | grep ' /var/tmp ' | awk '{print $1}')
    if [ -n "$vartmp_mount_info" ]; then
        echo -e "1.1.4.1 Ensure separate partition exists for /var/tmp --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.4.1 Ensure separate partition exists for /var/tmp --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if a separate partition exists for /var/tmp
check_separate_partition_vartmp
