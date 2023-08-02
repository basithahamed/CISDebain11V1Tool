#!/bin/bash

# Function to check if local interactive user dot files are not group or world writable
check_local_users_dot_files() {
    output=""
    perm_mask='0022'
    maxperm="$(printf '%o' $((0777 & ~$perm_mask)))"
    valid_shells="^($(sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' -))"
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (
        while read -r user home; do
            for dfile in $(find "$home" -type f -name '.*'); do
                mode=$(stat -L -c '%#a' "$dfile")
                [ $(( $mode & $perm_mask )) -gt 0 ] && output="$output\n- User $user file: \"$dfile\" is too permissive: \"$mode\" (should be: \"$maxperm\" or more restrictive)"
            done
        done

        if [ -n "$output" ]; then
            echo -e "\n6.2.17 Ensure local interactive user dot files are not group or world writable --> \e[31mfailed\e[0m:\n$output\n"
        else
            echo -e "\n6.2.17 Ensure local interactive user dot files are not group or world writable --> \033[0;32mpassed\033[0m: - All user home dot files are mode: \"$maxperm\" or more restrictive\n"
        fi
    )
}

# Call the function to check if local interactive user dot files are not group or world writable
check_local_users_dot_files
