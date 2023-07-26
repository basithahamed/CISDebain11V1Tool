#!/bin/bash

# Function to check if /var/log/audit is mounted on a separate partition
check_separate_partition_var_log_audit() {
    if [ -d "/var/log/audit" ]; then
        var_log_audit_mount=$(df -P /var/log/audit 2>/dev/null | tail -1 | awk '{print $1}')
        root_mount=$(df -P / 2>/dev/null | tail -1 | awk '{print $1}')

        if [ "$var_log_audit_mount" != "$root_mount" ]; then
            echo -e "1.1.6.1 Ensure separate partition exists for /var/log/audit --> \033[0;32mpass\033[0m"
        else
            echo -e "1.1.6.1 Ensure separate partition exists for /var/log/audit --> \033[0;31mfail\033[0m"
        fi
    else
        echo -e "1.1.6.1 Ensure separate partition exists for /var/log/audit --> \033[0;31mfail\033[0m (Directory not found)"
    fi
}

# Call the function to check if /var/log/audit is mounted on a separate partition
check_separate_partition_var_log_audit
