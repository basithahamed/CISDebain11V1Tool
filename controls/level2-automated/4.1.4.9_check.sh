#!/usr/bin/env bash

# Function to check audit tools ownership
check_audit_tools_ownership() {
    # Array of audit tools
    local audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")
    local l_unauthorized_files=""
    local has_failures=0

    for tool in "${audit_tools[@]}"; do
        if [ -x "$tool" ]; then
            local file_owner=$(stat -c "%U" "$tool")
            if [ "$file_owner" != "root" ]; then
                l_unauthorized_files+="\n$tool $file_owner"
                has_failures=1
            fi
        else
            l_unauthorized_files+="\n$tool not found"
            has_failures=1
        fi
    done

    if [ "$has_failures" -eq 0 ]; then
        echo -e "4.1.4.9 Ensure audit tools are owned by root --> \e[32mPASS\e[0m"
    else
        echo -e "4.1.4.9 Ensure audit tools are owned by root --> \e[31mFAIL\e[0m"
        echo -e "$l_unauthorized_files\n"
    fi
}

# Call the function to check the audit tools ownership
check_audit_tools_ownership
