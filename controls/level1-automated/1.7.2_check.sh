#!/bin/bash

# Function to check if the /etc/issue file contains the required warning banner
check_issue_banner() {
    local warning_banner="\\v\\r\\m\\s"
    local os_name=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')
    
    if grep -E -i "(\\v|\\r|\\m|\\s|$os_name)" /etc/issue &> /dev/null; then
        echo -e "1.7.2 Ensure local login warning banner is configured properly --> \033[0;31mfailed\033[0m"
    else
        echo -e "1.7.2 Ensure local login warning banner is configured properly --> \033[0;32mpassed\033[0m"
    fi
}

# Call the function to check the /etc/issue file for the warning banner
check_issue_banner
