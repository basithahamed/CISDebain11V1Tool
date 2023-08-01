#!/bin/bash

# Function to check if sudo commands use pty
check_sudo_use_pty() {
    grep -rPi '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers* > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\n5.3.2 Ensure sudo commands use pty --> \e[32mPASS\e[0m"
        echo -e "\n/etc/sudoers:Defaults use_pty\n"
    else
        echo -e "\n5.3.2 Ensure sudo commands use pty --> \e[31mFAIL\e[0m"
        echo -e "\n\"use_pty\" configuration not found in /etc/sudoers.\n"
    fi
}

# Call the function to check sudo use pty
check_sudo_use_pty
