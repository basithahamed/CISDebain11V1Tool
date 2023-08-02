#!/bin/bash

# Function to check if users must provide a password for privilege escalation
check_sudo_password_required() {
    local sudoers_with_nopasswd=$(grep -r "^[^#].*NOPASSWD" /etc/sudoers* | cut -d ":" -f 1)
    
    if [ -n "$sudoers_with_nopasswd" ]; then
        echo -e "\n5.3.4 Ensure users must provide password for privilege escalation --> \033[0;31mfailed\033[0m"
        cat "$sudoers_with_nopasswd"
    else
        echo -e "\n5.3.4 Ensure users must provide password for privilege escalation --> \033[0;32mpassed\033[0m"
    fi
}

# Call the function to check if users must provide a password for privilege escalation
check_sudo_password_required
