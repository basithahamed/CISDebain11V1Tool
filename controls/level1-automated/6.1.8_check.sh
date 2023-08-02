#!/bin/bash

# Function to check permissions on /etc/gshadow-
check_gshadow_minus_permissions() {
    local file="/etc/gshadow-"
    local permissions=$(stat -Lc "%a" "$file")
    local uid=$(stat -Lc "%u/%U" "$file")
    local gid=$(stat -Lc "%g/%G" "$file")

    if [ "$permissions" -ge 640 ] && [ "$uid" = "0/root" ] && [ "$gid" = "0/root" ]; then
        echo -e "6.1.8 Ensure permissions on /etc/gshadow- are configured --> \033[0;32mpassed\033[0m"
        echo -e "$file $permissions $uid $gid"
    else
        echo -e "6.1.8 Ensure permissions on /etc/gshadow- are configured --> \033[0;31mfailed\033[0m"
        echo -e "$file $permissions $uid $gid"
    fi
}

# Call the function to check permissions on /etc/gshadow-
check_gshadow_minus_permissions
