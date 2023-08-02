#!/usr/bin/env bash

# Function to check permissions on SSH public host key files
check_ssh_pubkey_permissions() {
    output=""
    find /etc/ssh -xdev -type f -name 'ssh_host_*_key.pub' -exec stat {} \; | while read -r line; do
        file=$(echo "$line" | awk -F "'" '{print $2}')
        access=$(echo "$line" | awk '{print $4}')
        
        if [[ "$access" != "-rw-r--r--" ]]; then
            output="$output\n- File: '$file' has incorrect access permissions: $access"
        fi
    done

    if [ -z "$output" ]; then
        echo -e "\n5.2.3 Ensure permissions on SSH public host key files are configured --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.3 Ensure permissions on SSH public host key files are configured --> \e[31mfailed\e[0m$output\n"
    fi
}

# Call the function to check permissions on SSH public host key files
check_ssh_pubkey_permissions
