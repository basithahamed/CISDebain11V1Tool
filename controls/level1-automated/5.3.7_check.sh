#!/bin/bash

# Function to check if access to the su command is restricted
check_su_access() {
    local su_config=$(grep -Pi "^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(\h+.*)?$" /etc/pam.d/su)
    
    if [ -n "$su_config" ]; then
        local group_name=$(echo "$su_config" | grep -oP "group=\K\w+")
        if [ -n "$group_name" ]; then
            local group_users=$(grep "^$group_name:" /etc/group | cut -d':' -f4)
            if [ -z "$group_users" ]; then
                echo -e "5.3.7 Ensure access to the su command is restricted --> \033[0;32mPass\033[0m (Group $group_name contains no users)"
            else
                echo -e "5.3.7 Ensure access to the su command is restricted --> \033[0;31mFail\033[0m (Group $group_name contains users: $group_users)"
            fi
        else
            echo -e "5.3.7 Ensure access to the su command is restricted --> \033[0;31mFail\033[0m (Group name not found in pam configuration)"
        fi
    else
        echo -e "5.3.7 Ensure access to the su command is restricted --> \033[0;31mFail\033[0m (Configuration not found in /etc/pam.d/su)"
    fi
}

# Call the function to check if access to the su command is restricted
check_su_access
