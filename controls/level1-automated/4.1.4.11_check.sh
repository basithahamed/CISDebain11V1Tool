#!/usr/bin/env bash

# Function to check AIDE configuration for audit tools
check_aide_audit_tools_config() {
    local audit_tool_list=("/sbin/auditctl" "/sbin/auditd" "/sbin/ausearch" "/sbin/aureport" "/sbin/autrace" "/sbin/augenrules")
    local l_output=""

    for tool in "${audit_tool_list[@]}"; do
        local tool_config=$(grep -Ps -- "(^$tool\h+|\s$tool\h+)" /etc/aide/aide.conf /etc/aide/aide.conf.d/*.conf)

        if [ -n "$tool_config" ]; then
            l_output+="$tool $tool_config\n"
        else
            l_output+="[!] $tool configuration not found\n"
        fi
    done

    local expected_config="p\+i\+n\+u\+g\+s\+b\+acl\+xattrs\+sha512"
    local all_aide_tools_configured=$(echo -e "$l_output" | grep -Pv -- "$expected_config")

    if [ -z "$all_aide_tools_configured" ]; then
        echo -e "4.1.4.11 Ensure cryptographic mechanisms are used to protect the integrity of audit tools --> \033[0;32mpassed\033[0m"
    else
        echo -e "4.1.4.11 Ensure cryptographic mechanisms are used to protect the integrity of audit tools --> \e[31mfailed\e[0m"
        echo -e "Expected configuration: $expected_config\n"
        echo -e "$all_aide_tools_configured"
    fi
}

# Call the function to check the AIDE configuration for audit tools
check_aide_audit_tools_config
