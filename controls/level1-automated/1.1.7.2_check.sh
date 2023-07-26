#!/bin/bash

# Function to check if the nodev option is set on the /home partition
check_nodev_option_home() {
    mount_options=$(grep -E '\s/home\s' /etc/fstab | awk '{print $4}')
    if [[ "$mount_options" == *"nodev"* ]]; then
        echo -e "1.1.7.2 Ensure nodev option set on /home partition --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.7.2 Ensure nodev option set on /home partition --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if the nodev option is set on the /home partition
check_nodev_option_home
