#!/bin/bash

# Function to check permissions on /etc/passwd
check_passwd_permissions() {
    local file="/etc/passwd"
    local permissions=$(stat -Lc "%a" "$file")
    local uid=$(stat -Lc "%u/%U" "$file")
    local gid=$(stat -Lc "%g/%G" "$file")
    
    if [ "$permissions" -ge 644 ] && [ "$uid" = "0/root" ] && [ "$gid" = "0/root" ]; then
        echo -e "6.1.1 Ensure permissions on /etc/passwd are configured --> \033[0;32mPASS\033[0m"
        echo -e "$file $permissions $uid $gid"
    else
        echo -e "6.1.1 Ensure permissions on /etc/passwd are configured --> \033[0;31mFAIL\033[0m"
        echo -e "$file $permissions $uid $gid"
    fi
}

# Call the function to check permissions on /etc/passwd
check_passwd_permissions
