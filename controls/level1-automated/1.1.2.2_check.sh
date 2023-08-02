#!/bin/bash

# Function to check if nodev option is set on /tmp partition
check_nodev_tmp_partition() {
    tmp_mount_options=$(mount | grep " /tmp " | awk '{print $6}')
    if [[ "$tmp_mount_options" == *"nodev"* ]]; then
        echo -e "1.1.2.2 Ensure nodev option set on /tmp partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.2.2 Ensure nodev option set on /tmp partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if nodev option is set on /tmp partition
check_nodev_tmp_partition
