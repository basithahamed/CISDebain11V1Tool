#!/bin/bash

# Function to check if local interactive users own their home directories
check_local_user_home_ownership() {
    output=""
    valid_shells="^($(sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' -))$"
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (
        while read -r user home; do
            owner="$(stat -L -c "%U" "$home")"
            [ "$owner" != "$user" ] && output="$output\n - User \"$user\" home directory \"$home\" is owned by user \"$owner\""
        done

        if [ -z "$output" ]; then
            echo -e "\n6.2.12 Ensure local interactive users own their home directories --> \033[0;32mpassed\033[0m: All local interactive users own their home directories\n"
        else
            echo -e "\n6.2.12 Ensure local interactive users own their home directories --> \e[31mfailed\e[0m:\n$output\n"
        fi
    )
}

# Call the function to check if local interactive users own their home directories
check_local_user_home_ownership
