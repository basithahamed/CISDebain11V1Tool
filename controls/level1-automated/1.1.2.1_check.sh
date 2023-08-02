#!/bin/bash

# Function to check if /tmp is a separate partition
check_tmp_partition() {
    tmp_mount=$(df -P /tmp | awk 'NR==2 {print $1}')
    root_mount=$(df -P / | awk 'NR==2 {print $1}')

    if [ "$tmp_mount" != "$root_mount" ]; then
        echo -e "1.1.2.1 Ensure /tmp is a separate partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.2.1 Ensure /tmp is a separate partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if /tmp is a separate partition
check_tmp_partition
