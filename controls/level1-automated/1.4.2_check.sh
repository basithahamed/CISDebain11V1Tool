#!/bin/bash

# Function to check permissions on bootloader config files
check_bootloader_permissions() {
    local bootloader_cfg="/boot/grub/grub.cfg"

    # Check if the bootloader config file exists
    if [ -e "$bootloader_cfg" ]; then
        # Check the permissions of the bootloader config file
        if [[ "$(stat -L -c "%a" "$bootloader_cfg")" == "600" ]]; then
            echo -e "1.4.2 Ensure permissions on bootloader config are configured --> \033[0;32mpassed\033[0m"
        else
            echo -e "1.4.2 Ensure permissions on bootloader config are configured --> \033[0;31mfailed\033[0m (Incorrect permissions)"
        fi
    else
        echo -e "1.4.2 Ensure permissions on bootloader config are configured --> \033[0;31mfailed\033[0m (Bootloader config not found)"
    fi
}

# Call the function to check permissions on bootloader config files
check_bootloader_permissions
