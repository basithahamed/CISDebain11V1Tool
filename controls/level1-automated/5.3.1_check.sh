#!/bin/bash

# Function to check if either sudo or sudo-ldap is installed
check_sudo_installation() {
    dpkg-query -W sudo sudo-ldap > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\n5.3.1 Ensure sudo is installed --> \e[32mPASS\e[0m"
        echo -e "\nPackage \"sudo\" or \"sudo-ldap\" is installed.\n"
    else
        echo -e "\n5.3.1 Ensure sudo is installed --> \e[31mFAIL\e[0m"
        echo -e "\nNeither \"sudo\" nor \"sudo-ldap\" package is installed.\n"
    fi
}

# Call the function to check sudo installation
check_sudo_installation
