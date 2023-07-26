#!/bin/bash

# Function to check if automounting is disabled
check_automounting() {
    service_status=$(systemctl is-enabled autofs 2>/dev/null)

    if [[ "$service_status" == "disabled" ]]; then
        echo -e "1.1.9 Disable Automounting --> \033[0;32mpass\033[0m"
    else
        echo -e "1.1.9 Disable Automounting --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if automounting is disabled
check_automounting
