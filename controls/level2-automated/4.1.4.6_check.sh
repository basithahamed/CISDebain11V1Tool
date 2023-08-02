#!/usr/bin/env bash

# Function to check audit configuration file ownership
check_audit_config_ownership() {
    # Check if the audit directory exists
    if [ ! -d "/etc/audit/" ]; then
        echo -e "4.1.4.6 Ensure audit configuration files are owned by root --> \e[31mfailed\e[0m"
        echo -e "\nAudit directory /etc/audit/ not found\n"
        exit 1
    fi

    local l_unauthorized_files=""
    while IFS= read -r -d '' file; do
        local file_owner=$(stat -c "%U" "$file")
        if [ "$file_owner" != "root" ]; then
            l_unauthorized_files+="\n$file $file_owner"
        fi
    done < <(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) -not -user root -print0)

    if [ -z "$l_unauthorized_files" ]; then
        echo -e "4.1.4.6 Ensure audit configuration files are owned by root --> \e[32mpassed\e[0m"
    else
        echo -e "4.1.4.6 Ensure audit configuration files are owned by root --> \e[31mfailed\e[0m"
        echo -e "\nUnauthorized audit configuration files:\n$l_unauthorized_files\n"
    fi
}

# Call the function to check the audit rule
check_audit_config_ownership
