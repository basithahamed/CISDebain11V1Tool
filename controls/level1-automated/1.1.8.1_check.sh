#!/bin/bash

# Function to check if the nodev option is set on the /dev/shm partition
check_nodev_option_dev_shm() {
    mount_options=$(grep -E '\s/dev/shm\s' /etc/fstab | awk '{print $4}')
    if [[ "$mount_options" == *"nodev"* ]]; then
        echo -e "1.1.8.1 Ensure nodev option set on /dev/shm partition --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.8.1 Ensure nodev option set on /dev/shm partition --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if the nodev option is set on the /dev/shm partition
check_nodev_option_dev_shm
