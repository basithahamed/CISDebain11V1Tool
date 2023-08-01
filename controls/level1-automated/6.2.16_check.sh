#!/bin/bash

# Function to check if local interactive users have .rhosts files
check_local_users_rhosts_files() {
    output=""
    fname=".rhosts"
    valid_shells="^($(sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' -))"
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (
        while read -r user home; do
            [ -f "$home/$fname" ] && output="$output\n - User \"$user\" file: \"$home/$fname\" exists"
        done

        if [ -z "$output" ]; then
            echo -e "\n6.2.16 Ensure no local interactive user has .rhosts files --> \e[32mPASS\e[0m: - No local interactive users have \"$fname\" files in their home directory\n"
        else
            echo -e "\n6.2.16 Ensure no local interactive user has .rhosts files --> \e[31mFAIL\e[0m:\n$output\n"
        fi
    )
}

# Call the function to check if local interactive users have .rhosts files
check_local_users_rhosts_files
