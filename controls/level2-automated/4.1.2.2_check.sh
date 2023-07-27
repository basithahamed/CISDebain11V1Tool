#!/bin/bash

# Function to check if audit logs are not automatically deleted
check_audit_log_automatic_deletion() {
    local max_log_file_action_config
    local output=""

    max_log_file_action_config=$(grep '^\h*max_log_file_action\h*=\h*' /etc/audit/auditd.conf | awk -F '=' '{print $2}' | tr -d '[:space:]')

    if [ "$max_log_file_action_config" = "keep_logs" ]; then
        output="audit logs are not automatically deleted"
    else
        output="audit logs are automatically deleted"
    fi

    echo -e "$output"
}

# Call the function to check audit log automatic deletion
result=$(check_audit_log_automatic_deletion)

if [ "$result" = "audit logs are not automatically deleted" ]; then
    echo -e "4.1.2.2 Ensure audit logs are not automatically deleted - \e[32mPass\e[0m"
    echo -e "\nResult:\n$result\n"
else
    echo -e "4.1.2.2 Ensure audit logs are not automatically deleted - \e[31mFail\e[0m"
    echo -e "\nResult:\n$result\n"
fi
