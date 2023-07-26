#!/bin/bash

# Function to check if cramfs module is loaded and disabled
check_cramfs() {
    if lsmod | grep -q '^cramfs'; then
        echo -e "1.1.1.1 Ensure mounting of cramfs filesystems is disabled --> \033[0;31mfail\033[0m"
    else
        echo -e "1.1.1.1 Ensure mounting of cramfs filesystems is disabled --> \033[0;32mpass\033[0m"
    fi
}

# Call the function to check cramfs status
check_cramfs
