#!/bin/bash

# Function to check if AIDE is installed
check_aide_installed() {
    if [ -n "$(command -v aide)" ]; then
        echo -e "1.3.1 Ensure AIDE is installed --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.3.1 Ensure AIDE is installed --> \033[0;31mfailed\033[0m (AIDE not installed)"
    fi
}

# Call the function to check if AIDE is installed
check_aide_installed
