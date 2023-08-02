#!/usr/bin/env bash

# Function to check audit log file group ownership
check_audit_log_group_ownership() {
    local l_auditd_conf="/etc/audit/auditd.conf"
    local l_audit_log_dir="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' "$l_auditd_conf" | xargs)")"

    if [ -f "$l_auditd_conf" ]; then
        local l_unauthorized_files=""
        local l_authorized_groups=("adm" "root")
        local l_authorized=false

        while IFS= read -r -d '' file; do
            local file_group=$(stat -c "%G" "$file")
            if ! [[ " ${l_authorized_groups[@]} " =~ " ${file_group} " ]]; then
                l_unauthorized_files+="\n$file $file_group"
            else
                l_authorized=true
            fi
        done < <(find "$l_audit_log_dir" -type f ! -group adm ! -group root -print0)

        if [ "$l_authorized" = true ]; then
            echo -e "4.1.4.3 Ensure only authorized groups are assigned ownership of audit log files --> \e[32mpassed\e[0m"
        else
            echo -e "4.1.4.3 Ensure only authorized groups are assigned ownership of audit log files --> \e[31mfailed\e[0m"
            echo -e "\nUnauthorized audit log files:\n$l_unauthorized_files\n"
        fi
    else
        echo -e "4.1.4.3 Ensure only authorized groups are assigned ownership of audit log files --> \e[31mfailed\e[0m"
        echo -e "\n/etc/audit/auditd.conf file not found!\n"
    fi
}

# Call the function to check the audit rule
check_audit_log_group_ownership
