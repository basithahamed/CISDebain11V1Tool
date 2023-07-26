#!/bin/bash

# Function to check the permissions on /etc/issue file
check_issue_permissions() {
    local issue_file="/etc/issue"
    local expected_uid="0"
    local expected_gid="0"
    local expected_permissions="644"

    if [ -e "$issue_file" ]; then
        local actual_uid=$(stat -L -c "%u" "$issue_file")
        local actual_gid=$(stat -L -c "%g" "$issue_file")
        local actual_permissions=$(stat -L -c "%a" "$issue_file")

        if [[ "$actual_uid" -eq "$expected_uid" && "$actual_gid" -eq "$expected_gid" && "$actual_permissions" -eq "$expected_permissions" ]]; then
            echo -e "1.7.5 Ensure permissions on /etc/issue are configured --> \033[0;32mpass\033[0m"
        else
            echo -e "1.7.5 Ensure permissions on /etc/issue are configured --> \033[0;31mfail\033[0m"
        fi
    else
        echo -e "1.7.5 Ensure permissions on /etc/issue are configured --> \033[0;32mpass\033[0m (File not found)"
    fi
}

# Call the function to check the permissions on /etc/issue file
check_issue_permissions
