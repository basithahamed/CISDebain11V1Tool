#!/bin/bash

# Function to check if AppArmor is enabled in the bootloader configuration
check_apparmor_enabled_bootloader() {
    if grep -Eqs '^\s*linux\s+/boot/vmlinuz.*\s+apparmor=1\b' /boot/grub/grub.cfg; then
        echo -e "1.6.1.2 Ensure AppArmor is enabled in the bootloader configuration --> \033[0;32mpassed\033[0m"
    else
        echo -e "1.6.1.2 Ensure AppArmor is enabled in the bootloader configuration --> \033[0;31mfailed\033[0m"
    fi
}

# Call the function to check if AppArmor is enabled in the bootloader configuration
check_apparmor_enabled_bootloader
