#!/bin/bash

# Function to check if bootloader password is set
check_bootloader_password() {
    if grep -q '^set superusers' /boot/grub/grub.cfg || grep -q '^password' /boot/grub/grub.cfg; then
        echo -e "1.4.1 Ensure bootloader password is set --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.4.1 Ensure bootloader password is set --> \033[0;31mfailed\033[0m (Bootloader password not set)"
    fi
}

# Call the function to check if bootloader password is set
check_bootloader_password
