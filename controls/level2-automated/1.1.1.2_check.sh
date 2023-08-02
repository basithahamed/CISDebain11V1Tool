#!/bin/bash

# Function to check if squashfs module is loaded and enabled
check_squashfs() {
    if lsmod | grep -q '^squashfs\s'; then
        echo -e "1.1.1.2 Ensure mounting of squashfs filesystems is disabled --> \033[0;31mfailed\033[0m"
    else
        echo -e "1.1.1.2 Ensure mounting of squashfs filesystems is disabled --> \033[0;32mpass\033[0m"
    fi
}

# Call the function to check squashfs status
check_squashfs
