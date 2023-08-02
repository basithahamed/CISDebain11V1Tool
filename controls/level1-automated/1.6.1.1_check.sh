#!/bin/bash

# Function to check if AppArmor is installed
check_apparmor_installed() {
    if which apparmor_parser &> /dev/null && which aa-status &> /dev/null; then
        echo -e "1.6.1.1 Ensure AppArmor is installed --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.6.1.1 Ensure AppArmor is installed --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if AppArmor is installed
check_apparmor_installed
