

#!/bin/bash

# Function to check if local interactive users have .forward files
check_local_users_forward_files() {
    output=""
    fname=".forward"
    valid_shells="^($(sed -rn '/^\//{s,/,\\\\/,g;p}' /etc/shells | paste -s -d '|' -))"
    awk -v pat="$valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd | (
        while read -r user home; do
            [ -f "$home/$fname" ] && output="$output\n - User \"$user\" file: \"$home/$fname\" exists"
        done

        if [ -z "$output" ]; then
            echo -e "\n6.2.15 Ensure no local interactive user has .forward files --> \033[0;32mpassed\033[0m: - No local interactive users have \"$fname\" files in their home directory\n"
        else
            echo -e "\n6.2.15 Ensure no local interactive user has .forward files --> \e[31mfailed\e[0m:\n$output\n"
        fi
    )
}

# Call the function to check if local interactive users have .forward files
check_local_users_forward_files
