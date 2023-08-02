#!/bin/bash

# Function to check if nodev option is set on /var partition
check_nodev_option_var() {
    var_mount_options=$(mount | grep ' on /var ' | awk '{print $6}')
    if [[ "$var_mount_options" == *"nodev"* ]]; then
        echo -e "1.1.3.2 Ensure nodev option set on /var partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.3.2 Ensure nodev option set on /var partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if nodev option is set on /var partition
check_nodev_option_var
