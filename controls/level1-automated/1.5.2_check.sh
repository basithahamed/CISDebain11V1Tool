#!/bin/bash

# Function to check if prelink is installed
check_prelink_not_installed() {
    if ! dpkg -s prelink &> /dev/null; then
        echo -e "1.5.2 Ensure prelink is not installed --> \033[0;32mpass\033[0m"
    else
        echo -e "1.5.2 Ensure prelink is not installed --> \033[0;31mfail\033[0m (prelink is installed)"
    fi
}

# Call the function to check if prelink is not installed
check_prelink_not_installed
