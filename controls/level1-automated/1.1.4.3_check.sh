#!/bin/bash

# Function to check if nosuid option is set on /var/tmp partition
check_nosuid_option_vartmp() {
    vartmp_mount_info=$(mount | grep ' /var/tmp ' | awk '{print $6}')
    if [[ "$vartmp_mount_info" == *"nosuid"* ]]; then
        echo -e "1.1.4.3 Ensure nosuid option set on /var/tmp partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.4.3 Ensure nosuid option set on /var/tmp partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if nosuid option is set on /var/tmp partition
check_nosuid_option_vartmp
