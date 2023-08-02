#!/bin/bash

# Function to check the permissions on /etc/issue.net file
check_issue_net_permissions() {
    local issue_net_file="/etc/issue.net"
    local expected_uid="0"
    local expected_gid="0"
    local expected_permissions="644"

    if [ -e "$issue_net_file" ]; then
        local actual_uid=$(stat -L -c "%u" "$issue_net_file")
        local actual_gid=$(stat -L -c "%g" "$issue_net_file")
        local actual_permissions=$(stat -L -c "%a" "$issue_net_file")

        if [[ "$actual_uid" -eq "$expected_uid" && "$actual_gid" -eq "$expected_gid" && "$actual_permissions" -eq "$expected_permissions" ]]; then
            echo -e "1.7.6 Ensure permissions on /etc/issue.net are configured --> \033[0;32mpassed\033[0m"
        else
            echo -e "1.7.6 Ensure permissions on /etc/issue.net are configured --> \033[0;31mfailed\033[0m"
        fi
    else
        echo -e "1.7.6 Ensure permissions on /etc/issue.net are configured --> \033[0;32mpassed\033[0m (File not found)"
    fi
}

# Call the function to check the permissions on /etc/issue.net file
check_issue_net_permissions
