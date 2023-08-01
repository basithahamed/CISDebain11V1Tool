#!/bin/bash

# Function to check if cramfs module is loaded and disabled
check_cramfs() {
    if lsmod | grep -q '^cramfs'; then
        echo -e "1.1.1.1 Ensure mounting of cramfs filesystems is disabled --> \033[0;31mfail\033[0m"
    else
        echo -e "1.1.1.1 Ensure mounting of cramfs filesystems is disabled --> \033[0;32mpass\033[0m"
    fi
}

# Call the function and store the output in a variable
result=$(controls/level1-automated/1.1.1.1_check.sh)

# Check if the output contains '--> pass'
if echo "$result" | grep -q -- ' --> pass'; then
    echo "The script passed the check."
else
    echo "The script failed the check."
fi
