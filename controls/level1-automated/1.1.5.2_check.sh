#!/bin/bash

# Function to check if nodev option is set on /var/log partition
check_nodev_varlog() {
    varlog_mount_options=$(mount | grep 'on /var/log ' | awk '{print $6}')
    if [[ "$varlog_mount_options" == *"nodev"* ]]; then
        echo -e "1.1.5.2 Ensure nodev option set on /var/log partition --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.5.2 Ensure nodev option set on /var/log partition --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if nodev option is set on /var/log partition
check_nodev_varlog
