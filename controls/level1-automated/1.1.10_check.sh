#!/bin/bash

# Function to check if USB storage is disabled
check_usb_storage() {
    if grep -Eqs '\s+/usb-storage\s+' /etc/modprobe.d/*; then
        echo -e "1.1.10 Ensure USB storage is disabled --> \033[0;31mfailed\033[0m"
    else
        echo -e "1.1.10 Ensure USB storage is disabled --> \033[0;32mpassed\033[0m"
    fi
}

# Call the function to check the status of USB storage
check_usb_storage
