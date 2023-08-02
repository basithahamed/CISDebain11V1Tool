#!/bin/bash

# Function to check if the default user umask is set to enforce directory and file permissions
check_default_umask() {
    local passing=""

    grep -Eiq '^\s*UMASK\s+(0[0-7][2-7]7|[0-7][2-7]7)\b' /etc/login.defs && \
    grep -Eiq '^\s*USERGROUPS_ENAB\s*"?no"?\b' /etc/login.defs && \
    grep -Eq '^\s*session\s+(optional|requisite|required)\s+pam_umask\.so\b' /etc/pam.d/common-session && \
    passing=true

    grep -REiq '^\s*UMASK\s+\s*(0[0-7][2-7]7|[0-7][2-7]7|u=(r?|w?|x?)(r?|w?|x?)(r?|w?|x?),g=(r?x?|x?r?),o=)\b' /etc/profile* /etc/bash.bashrc* && \
    passing=true

    if [ "$passing" = true ]; then
        echo -e "5.5.4 Ensure default user umask is 027 or more restrictive --> \033[0;32mpassed\033[0m"
    else
        echo -e "5.5.4 Ensure default user umask is 027 or more restrictive --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check the default user umask
check_default_umask
