#!/usr/bin/env bash

# Function to check if systemd-journal-remote is installed
check_systemd_journal_remote_installed() {
    local package_status=$(dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' systemd-journal-remote)
    local installed_status=$(echo "$package_status" | awk '{print $3}')

    if [ "$installed_status" = "installed" ]; then
        echo -e "\n4.2.1.1.1 Ensure systemd-journal-remote is installed --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n4.2.1.1.1 Ensure systemd-journal-remote is installed --> \e[31mfailed\e[0m"
        echo -e "Package status: $package_status\n"
    fi
}

# Call the function to check if systemd-journal-remote is installed
check_systemd_journal_remote_installed
