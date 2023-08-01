#!/usr/bin/env bash

# Function to check audit log directory permissions
check_audit_log_directory_permissions() {
    local l_auditd_conf="/etc/audit/auditd.conf"
    local l_audit_log_dir="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' "$l_auditd_conf" | xargs)")"

    if [ -d "$l_audit_log_dir" ]; then
        local l_unauthorized_dirs=""
        while IFS= read -r -d '' dir; do
            local dir_permissions=$(stat -c "%a" "$dir")
            if ! [[ "$dir_permissions" =~ ^[0,5,7][0,5]0$ ]]; then
                l_unauthorized_dirs+="\n$dir $dir_permissions"
            fi
        done < <(find "$l_audit_log_dir" -type d -print0)

        if [ -z "$l_unauthorized_dirs" ]; then
            echo -e "4.1.4.4 Ensure the audit log directory is 0750 or more restrictive --> \e[32mPASS\e[0m"
        else
            echo -e "4.1.4.4 Ensure the audit log directory is 0750 or more restrictive --> \e[31mFAIL\e[0m"
            echo -e "\nUnauthorized audit log directories:\n$l_unauthorized_dirs\n"
        fi
    else
        echo -e "4.1.4.4 Ensure the audit log directory is 0750 or more restrictive --> \e[31mFAIL\e[0m"
        echo -e "\nAudit log directory not found!\n"
    fi
}

# Call the function to check the audit rule
check_audit_log_directory_permissions
