#!/bin/bash

# Function to check permissions on /etc/shadow-
check_shadow_dash_permissions() {
    local file="/etc/shadow-"
    local permissions=$(stat -Lc "%a" "$file")
    local uid=$(stat -Lc "%u/%U" "$file")
    local gid=$(stat -Lc "%g/%G" "$file")

    if [ "$permissions" -ge 640 ] && [ "$uid" = "0/root" ] && [ "$gid" = "0/root" ]; then
        echo -e "6.1.6 Ensure permissions on /etc/shadow- are configured --> \033[0;32mpassed\033[0m"
        echo -e "$file $permissions $uid $gid"
    else
        echo -e "6.1.6 Ensure permissions on /etc/shadow- are configured --> \033[0;31mfailed\033[0m"
        echo -e "$file $permissions $uid $gid"
    fi
}

# Call the function to check permissions on /etc/shadow-
check_shadow_dash_permissions
