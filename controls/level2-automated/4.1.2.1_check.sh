#!/bin/bash

# Function to check the audit log storage size configuration
check_audit_log_storage_size() {
    if ! dpkg -l auditd &>/dev/null; then
        echo -e "\n4.1.2.1 Ensure audit log storage size is configured - \e[31mFail\e[0m"
        echo "auditd is not installed"
        exit 1
    fi

    local max_log_file_config
    local output=""

    max_log_file_config=$(grep -Po -- '^\h*max_log_file\h*=\h*\d+\b' /etc/audit/auditd.conf)

    if [ -n "$max_log_file_config" ]; then
        max_log_file_value=$(grep -Po -- '^\h*max_log_file\h*=\h*\K\d+' /etc/audit/auditd.conf)
        output="audit log storage size is configured: $max_log_file_value MB"
        echo -e "\n4.1.2.1 Ensure audit log storage size is configured - \e[32mPass\e[0m"
        echo -e "\nResult:\n$output\n"
        exit 0
    else
        output="audit log storage size is not configured in /etc/audit/auditd.conf"
        echo -e "\n4.1.2.1 Ensure audit log storage size is configured - \e[31mFail\e[0m"
        echo -e "\nResult:\n$output\n"
        exit 1
    fi
}

# Call the function to check audit log storage size configuration
check_audit_log_storage_size
