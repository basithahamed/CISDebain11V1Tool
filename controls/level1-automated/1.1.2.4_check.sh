#!/bin/bash

# Function to check if nosuid option is set on /tmp partition
check_nosuid_tmp_partition() {
    tmp_mount_options=$(mount | grep " /tmp " | awk '{print $6}')
    if [[ "$tmp_mount_options" == *"nosuid"* ]]; then
        echo -e "1.1.2.4 Ensure nosuid option set on /tmp partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.2.4 Ensure nosuid option set on /tmp partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if nosuid option is set on /tmp partition
check_nosuid_tmp_partition
