#!/bin/bash

# Function to check if noexec option is set on /tmp partition
check_noexec_tmp_partition() {
    tmp_mount_options=$(mount | grep " /tmp " | awk '{print $6}')
    if [[ "$tmp_mount_options" == *"noexec"* ]]; then
        echo -e "1.1.2.3 Ensure noexec option set on /tmp partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.2.3 Ensure noexec option set on /tmp partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if noexec option is set on /tmp partition
check_noexec_tmp_partition

