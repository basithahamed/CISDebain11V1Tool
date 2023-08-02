#!/bin/bash

# Function to check if local interactive users have .netrc files
check_local_users_netrc_files() {
    output=""
    output2=""
    perm_mask='0177'
    maxperm="$(printf '%o' $((0777 & ~$perm_mask)))"
    valid_shells="^($(sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' -))"
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (
        while read -r user home; do
            if [ -f "$home/.netrc" ]; then
                mode="$(stat -L -c '%#a' "$home/.netrc")"
                if [ $((mode & perm_mask)) -gt 0 ]; then
                    output="$output\n - User \"$user\" file: \"$home/.netrc\" is too permissive: \"$mode\" (should be: \"$maxperm\" or more restrictive)"
                else
                    output2="$output2\n - User \"$user\" file: \"$home/.netrc\" exists and has file mode: \"$mode\" (should be: \"$maxperm\" or more restrictive)"
                fi
            fi
        done

        if [ -z "$output" ]; then
            if [ -z "$output2" ]; then
                echo -e "\n6.2.14 Ensure no local interactive user has .netrc files --> \033[0;32mpassed\033[0m: - No local interactive users have \".netrc\" files in their home directory\n"
            else
                echo -e "\n6.2.14 Ensure no local interactive user has .netrc files --> \e[33mWARNING\e[0m:\n$output2\n"
            fi
        else
            echo -e "\n6.2.14 Ensure no local interactive user has .netrc files --> \e[31mfailed\e[0m:\n$output\n"
            [ -n "$output2" ] && echo -e "\n\e[33mWARNING\e[0m:\n$output2\n"
        fi
    )
}

# Call the function to check if local interactive users have .netrc files
check_local_users_netrc_files
