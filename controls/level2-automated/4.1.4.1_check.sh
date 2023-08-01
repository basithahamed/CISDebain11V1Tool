#!/usr/bin/env bash

# Function to check audit log file permissions
check_audit_log_permissions() {
    local l_auditd_conf="/etc/audit/auditd.conf"
    local l_audit_log_dir="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' "$l_auditd_conf" | xargs)")"

    if [ -f "$l_auditd_conf" ]; then
        local l_files_wrong_permissions=""
        local l_wrong_permissions=false

        while IFS= read -r -d '' file; do
            local file_permissions=$(stat -c "%a" "$file")
            if [ "$file_permissions" -gt 640 ] || [ "$file_permissions" -lt 600 ]; then
                l_files_wrong_permissions+="\n$file $file_permissions"
                l_wrong_permissions=true
            fi
        done < <(find "$l_audit_log_dir" -type f \( ! -perm 600 -a ! -perm 0400 -a ! -perm 0200 -a ! -perm 0000 -a ! -perm 0640 -a ! -perm 0440 -a ! -perm 0040 \) -print0)

        if [ "$l_wrong_permissions" = true ]; then
            echo -e "4.1.4.1 Ensure audit log files are mode 0640 or less permissive --> \e[31mFAIL\e[0m"
            echo -e "\nAudit log files with incorrect permissions:\n$l_files_wrong_permissions\n"
        else
            echo -e "4.1.4.1 Ensure audit log files are mode 0640 or less permissive --> \e[32mPASS\e[0m"
        fi
    else
        echo -e "4.1.4.1 Ensure audit log files are mode 0640 or less permissive --> \e[31mFAIL\e[0m"
        echo -e "\n/etc/audit/auditd.conf file not found!\n"
    fi
}

# Call the function to check the audit rule
check_audit_log_permissions
