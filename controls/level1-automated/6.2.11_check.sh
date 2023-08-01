#!/usr/bin/env bash

# Function to check if home directories of local interactive users exist
check_home_directories_exist() {
    output=""
    valid_shells="^($(sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' -))$"
    
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | while read -r user home; do
        [ ! -d "$home" ] && output="$output\n - User \"$user\" home directory \"$home\" doesn't exist"
    done
    
    if [ -z "$output" ]; then
        echo -e "6.2.11 Ensure local interactive user home directories exist --> \e[32mPASS\e[0m: All local interactive users have a home directory"
    else
        echo -e "6.2.11 Ensure local interactive user home directories exist --> \e[31mFAIL\e[0m:$output\n"
    fi
}

# Call the function to check home directories of local interactive users
check_home_directories_exist
