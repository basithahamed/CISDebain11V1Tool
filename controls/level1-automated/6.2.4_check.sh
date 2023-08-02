#!/bin/bash

# Check if the shadow group is empty
check_shadow_group_empty() {
    local shadow_gid=$(awk -F: '($1=="shadow") {print $3}' /etc/group)
    local shadow_users=$(awk -F: -v GID="$shadow_gid" '($4==GID) {print $1}' /etc/passwd)

    if [ -z "$shadow_users" ]; then
        echo -e "6.2.4 Ensure shadow group is empty --> \033[0;32mpassed\033[0m"
    else
        echo -e "6.2.4 Ensure shadow group is empty --> \e[31mfailed\e[0m"
    fi
}

# Call the function to check the shadow group
check_shadow_group_empty
