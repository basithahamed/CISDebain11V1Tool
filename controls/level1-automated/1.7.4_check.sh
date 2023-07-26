#!/bin/bash

# Function to check the permissions on /etc/motd file
check_motd_permissions() {
    local motd_file="/etc/motd"
    local expected_uid="0"
    local expected_gid="0"
    local expected_permissions="644"

    if [ -e "$motd_file" ]; then
        local actual_uid=$(stat -L -c "%u" "$motd_file")
        local actual_gid=$(stat -L -c "%g" "$motd_file")
        local actual_permissions=$(stat -L -c "%a" "$motd_file")

        if [[ "$actual_uid" -eq "$expected_uid" && "$actual_gid" -eq "$expected_gid" && "$actual_permissions" -eq "$expected_permissions" ]]; then
            echo -e "1.7.4 Ensure permissions on /etc/motd are configured --> \033[0;32mpass\033[0m"
        else
            echo -e "1.7.4 Ensure permissions on /etc/motd are configured --> \033[0;31mfail\033[0m"
        fi
    else
        echo -e "1.7.4 Ensure permissions on /etc/motd are configured --> \033[0;32mpass\033[0m (File not found)"
    fi
}

# Call the function to check the permissions on /etc/motd file
check_motd_permissions
