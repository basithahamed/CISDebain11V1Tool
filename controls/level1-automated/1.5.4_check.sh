#!/bin/bash

# Function to check if core dumps are restricted
check_core_dumps_restricted() {
    if grep -q "hard core 0" /etc/security/limits.conf && grep -q "fs.suid_dumpable = 0" /etc/sysctl.conf; then
        echo -e "1.5.4 Ensure core dumps are restricted --> \033[0;32mpass\033[0m"
    else
        echo -e "1.5.4 Ensure core dumps are restricted --> \033[0;31mfail\033[0m"
    fi
}

# Call the function to check if core dumps are restricted
check_core_dumps_restricted
