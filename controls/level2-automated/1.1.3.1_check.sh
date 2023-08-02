#!/bin/bash

# Function to check if a separate partition exists for /var
check_separate_partition_var() {
    var_mount_point=$(df -P /var | awk 'NR==2 {print $6}')
    if [ "$var_mount_point" != "/" ]; then
        echo -e "1.1.3.1 Ensure separate partition exists for /var --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.3.1 Ensure separate partition exists for /var --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if a separate partition exists for /var
check_separate_partition_var
