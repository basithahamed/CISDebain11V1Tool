#!/bin/bash

# Function to check if nosuid option is set on /var partition
check_nosuid_option_var() {
    var_mount_options=$(mount | grep ' on /var ' | awk '{print $6}')
    if [[ "$var_mount_options" == *"nosuid"* ]]; then
        echo -e "1.1.3.3 Ensure nosuid option set on /var partition --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.3.3 Ensure nosuid option set on /var partition --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if nosuid option is set on /var partition
check_nosuid_option_var
