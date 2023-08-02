#!/usr/bin/env bash

# Function to check audit tools ownership
check_audit_tools_ownership() {
    # Array of audit tools
    local audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")
    local l_unauthorized_files=""
    local has_failures=0

    for tool in "${audit_tools[@]}"; do
        if [ -x "$tool" ]; then
            local file_mode=$(stat -c "%a" "$tool")
            local file_owner=$(stat -c "%U" "$tool")
            local file_group=$(stat -c "%G" "$tool")

            if ! [[ "$file_mode" =~ ^[0-7][0,1,4,5][0,1,4,5]$ ]] || [ "$file_owner" != "root" ] || [ "$file_group" != "root" ]; then
                l_unauthorized_files+="\n$tool $file_mode $file_owner $file_group"
                has_failures=1
            fi
        else
            l_unauthorized_files+="\n$tool not found"
            has_failures=1
        fi
    done

    if [ "$has_failures" -eq 0 ]; then
        echo -e "4.1.4.10 Ensure audit tools belong to group root --> \e[32mpassed\e[0m"
    else
        echo -e "4.1.4.10 Ensure audit tools belong to group root --> \e[31mfailed\e[0m"
        echo -e "$l_unauthorized_files\n"
    fi
}

# Call the function to check the audit tools ownership
check_audit_tools_ownership


