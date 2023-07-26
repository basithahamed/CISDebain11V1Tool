#!/bin/bash

# Function to check if the nosuid option is set on the /dev/shm partition
check_nosuid_option_dev_shm() {
    mount_options=$(grep -E '\s/dev/shm\s' /etc/fstab | awk '{print $4}')
    if [[ "$mount_options" == *"nosuid"* ]]; then
        echo -e "1.1.8.3 Ensure nosuid option set on /dev/shm partition --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.8.3 Ensure nosuid option set on /dev/shm partition --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if the nosuid option is set on the /dev/shm partition
check_nosuid_option_dev_shm
