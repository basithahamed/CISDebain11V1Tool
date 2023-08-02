#!/usr/bin/env bash

# Function to check audit tools permissions
check_audit_tools_permissions() {
    # Array of audit tools
    local audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")
    local l_unauthorized_files=""
    local has_failures=0

    for tool in "${audit_tools[@]}"; do
        if [ -x "$tool" ]; then
            local file_perms=$(stat -c "%a" "$tool")
            local file_owner=$(stat -c "%U" "$tool")
            local file_group=$(stat -c "%G" "$tool")

            if [[ "$file_perms" =~ ^[0-7]{3}$ && "$file_perms" -lt 755 ]] || [ "$file_owner" != "root" ] || [ "$file_group" != "root" ]; then
                l_unauthorized_files+="\n$tool $file_perms $file_owner:$file_group"
                has_failures=1
            fi
        else
            l_unauthorized_files+="\n$tool not found"
            has_failures=1
        fi
    done

    if [ "$has_failures" -eq 0 ]; then
        echo -e "4.1.4.8 Ensure audit tools are 755 or more restrictive --> \e[32mpassed\e[0m"
    else
        echo -e "4.1.4.8 Ensure audit tools are 755 or more restrictive --> \e[31mfailed\e[0m"
        echo -e "$l_unauthorized_files\n"
    fi
}

# Call the function to check the audit tools permissions
check_audit_tools_permissions
