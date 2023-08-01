#!/bin/bash

# Function to check if root is the only UID 0 account
check_root_uid_account() {
    local root_accounts=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)
    
    if [ "$(echo "$root_accounts" | wc -l)" -eq 1 ] && [ "$root_accounts" = "root" ]; then
        echo -e "6.2.10 Ensure root is the only UID 0 account --> \e[32mPASS\e[0m: Only 'root' account has UID 0"
    else
        echo -e "6.2.10 Ensure root is the only UID 0 account --> \e[31mFAIL\e[0m: There are other accounts with UID 0"
    fi
}

# Call the function to check if root is the only UID 0 account
check_root_uid_account
