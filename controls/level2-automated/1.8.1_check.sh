#!/bin/bash

# Function to check if gdm3 is not installed
check_gdm3_not_installed() {
    if ! dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' gdm3 2>/dev/null | grep -q "^gdm3[[:space:]]*install[[:space:]]*ok"; then
        echo -e "1.8.1 Ensure GNOME Display Manager is removed --> \033[0;32mpass\033[0m"
    else
        echo -e "1.8.1 Ensure GNOME Display Manager is removed --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if gdm3 is not installed
check_gdm3_not_installed
