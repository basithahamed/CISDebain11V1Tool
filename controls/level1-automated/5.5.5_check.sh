#!/bin/bash

# Function to check if TMOUT is configured as expected
check_tmout_configuration() {
    local output1=""
    local output2=""
    local BRC="/etc/bash.bashrc"

    for f in "$BRC" /etc/profile /etc/profile.d/*.sh; do
        grep -Pq '^\s*([^#]+\s+)?TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\b' "$f" && \
        grep -Pq '^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && \
        grep -Pq '^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" && \
        output1="$f"
    done

    grep -Pq '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC" && \
    output2=$(grep -Ps '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC")

    if [ -n "$output1" ] && [ -z "$output2" ]; then
        echo -e "5.5.5 Ensure default user shell timeout is 900 seconds or less --> \033[0;32mpassed\033[0m"
        echo -e "\nTMOUT is configured in: \"$output1\"\n"
    else
        [ -z "$output1" ] && echo -e "5.5.5 Ensure default user shell timeout is 900 seconds or less --> \033[0;31mfailed\033[0m\n\nTMOUT is not configured\n"
        [ -n "$output2" ] && echo -e "5.5.5 Ensure default user shell timeout is 900 seconds or less --> \033[0;31mfailed\033[0m\n\nTMOUT is incorrectly configured in: \"$output2\"\n"
    fi
}

# Call the function to check TMOUT configuration
check_tmout_configuration
