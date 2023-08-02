#!/bin/bash

# Function to check if re-authentication for privilege escalation is not disabled globally
check_sudo_reauth_disabled() {
    local sudoers_with_disable_reauth=$(grep -r "^[^#].*\!authenticate" /etc/sudoers* | cut -d ":" -f 1)

    if [ -n "$sudoers_with_disable_reauth" ]; then
        echo -e "\n5.3.5 Ensure re-authentication for privilege escalation is not disabled globally --> \033[0;31mfailed\033[0m"
        cat "$sudoers_with_disable_reauth"
    else
        echo -e "\n5.3.5 Ensure re-authentication for privilege escalation is not disabled globally --> \033[0;32mpassed\033[0m"
    fi
}

# Call the function to check if re-authentication for privilege escalation is not disabled globally
check_sudo_reauth_disabled
