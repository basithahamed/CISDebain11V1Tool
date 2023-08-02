#!/usr/bin/env bash

# Function to check audit configuration file permissions
check_audit_config_permissions() {
    local l_unauthorized_files=""
    while IFS= read -r -d '' file; do
        local file_permissions=$(stat -c "%a" "$file")
        if ! [[ "$file_permissions" =~ ^[0,2,4,6][0,4]0$ ]]; then
            l_unauthorized_files+="\n$file $file_permissions"
        fi
    done < <(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) -print0)

    if [ -z "$l_unauthorized_files" ]; then
        echo -e "4.1.4.5 Ensure audit configuration files are 640 or more restrictive --> \e[32mpassed\e[0m"
    else
        echo -e "4.1.4.5 Ensure audit configuration files are 640 or more restrictive --> \e[31mfailed\e[0m"
        echo -e "\nUnauthorized audit configuration files:\n$l_unauthorized_files\n"
    fi
}

# Call the function to check the audit rule
check_audit_config_permissions
