#!/bin/bash

# Function to check if noexec option is set on /var/tmp partition
check_noexec_option_vartmp() {
    vartmp_mount_info=$(mount | grep ' /var/tmp ' | awk '{print $6}')
    if [[ "$vartmp_mount_info" == *"noexec"* ]]; then
        echo -e "1.1.4.2 Ensure noexec option set on /var/tmp partition --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.1.4.2 Ensure noexec option set on /var/tmp partition --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if noexec option is set on /var/tmp partition
check_noexec_option_vartmp
