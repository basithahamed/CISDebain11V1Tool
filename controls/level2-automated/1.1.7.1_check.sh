#!/bin/bash

# Function to check if a separate partition exists for /home
check_separate_partition_home() {
    mount_point=$(df -P /home | tail -1 | awk '{print $6}')
    if [ "$mount_point" != "/" ]; then
        echo -e "1.1.7.1 Ensure separate partition exists for /home --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.7.1 Ensure separate partition exists for /home --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if a separate partition exists for /home
check_separate_partition_home
