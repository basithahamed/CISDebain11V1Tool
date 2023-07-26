#!/bin/bash

# Function to check if GPG keys are configured
check_gpg_keys() {
    if [ -n "$(command -v gpg)" ]; then
        gpg_keys=$(gpg --list-keys)
        if [ -n "$gpg_keys" ]; then
            echo -e "1.2.2 Ensure GPG keys are configured --> \033[0;32mpass\033[0m"
        else
            echo -e "1.2.2 Ensure GPG keys are configured --> \033[0;31mfail\033[0m (No GPG keys found)"
        fi
    else
        echo -e "1.2.2 Ensure GPG keys are configured --> \033[0;31mfail\033[0m (GPG not installed)"
    fi
}

# Call the function to check the status of GPG keys
check_gpg_keys
