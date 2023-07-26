#!/bin/bash

# Function to check if Address Space Layout Randomization (ASLR) is enabled
check_aslr_enabled() {
    local aslr_value=$(sysctl -n kernel.randomize_va_space)

    if [ "$aslr_value" -eq 2 ]; then
        echo -e "1.5.1 Ensure address space layout randomization (ASLR) is enabled --> \033[0;32mpass\033[0m"
    else
        echo -e "1.5.1 Ensure address space layout randomization (ASLR) is enabled --> \033[0;31mfail\033[0m (ASLR is not More than value 2)"
    fi
}

# Call the function to check if ASLR is enabled
check_aslr_enabled
