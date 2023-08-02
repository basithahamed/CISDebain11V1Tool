#!/usr/bin/env bash

# Function to check audit log file ownership
check_audit_log_ownership() {
    local l_auditd_conf="/etc/audit/auditd.conf"
    local l_audit_log_dir="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' "$l_auditd_conf" | xargs)")"

    if [ -f "$l_auditd_conf" ]; then
        local l_files_wrong_ownership=""
        local l_wrong_ownership=false

        while IFS= read -r -d '' file; do
            local file_owner=$(stat -c "%U" "$file")
            if [ "$file_owner" != "root" ]; then
                l_files_wrong_ownership+="\n$file $file_owner"
                l_wrong_ownership=true
            fi
        done < <(find "$l_audit_log_dir" -type f ! -user root -print0)

        if [ "$l_wrong_ownership" = true ]; then
            echo -e "4.1.4.2 Ensure only authorized users own audit log files --> \e[31mfailed\e[0m"
            echo -e "\nAudit log files not owned by root user:\n$l_files_wrong_ownership\n"
        else
            echo -e "4.1.4.2 Ensure only authorized users own audit log files --> \e[32mpassed\e[0m"
        fi
    else
        echo -e "4.1.4.2 Ensure only authorized users own audit log files --> \e[31mfailed\e[0m"
        echo -e "\n/etc/audit/auditd.conf file not found!\n"
    fi
}

# Call the function to check the audit rule
check_audit_log_ownership
