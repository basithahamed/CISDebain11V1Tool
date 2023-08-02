#!/bin/bash

# Function to check if local interactive user home directories are mode 750 or more restrictive
check_local_user_home_permissions() {
    output=""
    perm_mask='0027'
    maxperm="$(printf '%o' $((0777 & ~$perm_mask)))"
    valid_shells="^($(sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' -))"
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (
        while read -r user home; do
            if [ -d "$home" ]; then
                mode=$(stat -L -c '%#a' "$home")
                [ $((mode & perm_mask)) -gt 0 ] && output="$output\n- User $user home directory: \"$home\" is too permissive: \"$mode\" (should be: \"$maxperm\" or more restrictive)"
            fi
        done

        if [ -n "$output" ]; then
            echo -e "\n6.2.13 Ensure local interactive user home directories are mode 750 or more restrictive --> \e[31mfailed\e[0m:$output"
        else
            echo -e "\n6.2.13 Ensure local interactive user home directories are mode 750 or more restrictive --> \033[0;32mpassed\033[0m:\n- All user home directories are mode: \"$maxperm\" or more restrictive"
        fi
    )
}

# Call the function to check if local interactive user home directories are mode 750 or more restrictive
check_local_user_home_permissions
