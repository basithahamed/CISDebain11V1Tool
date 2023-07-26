#!/bin/bash

# Function to check if package manager repositories are configured
check_package_repositories() {
    if [ -f "/etc/apt/sources.list" ]; then
        echo -e "1.2.1 Ensure package manager repositories are configured --> \033[0;32mpass\033[0m (APT)"
    elif [ -f "/etc/yum.repos.d" ] && [ "$(ls -A /etc/yum.repos.d)" ]; then
        echo -e "1.2.1 Ensure package manager repositories are configured --> \033[0;32mpass\033[0m (YUM)"
    else
        echo -e "1.2.1 Ensure package manager repositories are configured --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check the status of package manager repositories
check_package_repositories
