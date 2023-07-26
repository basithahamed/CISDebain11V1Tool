#!/bin/bash

# Function to check if udf module is loaded and enabled
check_udf() {
    if lsmod | grep -q '^udf\s'; then
        echo -e "1.1.1.3 Ensure mounting of udf filesystems is disabled --> \033[0;31mfail\033[0m"
    else
        echo -e "1.1.1.3 Ensure mounting of udf filesystems is disabled --> \033[0;32mpass\033[0m"
    fi
}

# Call the function to check udf status
check_udf
