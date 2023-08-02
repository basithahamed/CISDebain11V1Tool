#!/bin/bash

# Function to check if the default group for the root account is GID 0
check_default_root_group_gid() {
    root_gid=$(grep "^root:" /etc/passwd | cut -f4 -d:)
    if [ "$root_gid" -eq 0 ]; then
        echo -e "5.5.3 Ensure default group for the root account is GID 0 --> \e[32mpassed\e[0m"
    else
        echo -e "5.5.3 Ensure default group for the root account is GID 0 --> \e[31mfailed\e[0m"
    fi
}

# Call the function to check the default group for the root account
check_default_root_group_gid
