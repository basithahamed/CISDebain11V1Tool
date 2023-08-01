#!/usr/bin/env bash

# Function to check audit configuration file group ownership
check_audit_config_group_ownership() {
    local l_unauthorized_files=""
    while IFS= read -r -d '' file; do
        local file_group=$(stat -c "%G" "$file")
        if [ "$file_group" != "root" ]; then
            l_unauthorized_files+="\n$file $file_group"
        fi
    done < <(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root -print0)

    if [ -z "$l_unauthorized_files" ]; then
        echo -e "4.1.4.7 Ensure audit configuration files belong to group root --> \e[32mPASS\e[0m"
    else
        echo -e "4.1.4.7 Ensure audit configuration files belong to group root --> \e[31mFAIL\e[0m"
        echo -e "\nUnauthorized audit configuration files:\n$l_unauthorized_files\n"
    fi
}

# Call the function to check the audit rule
check_audit_config_group_ownership
