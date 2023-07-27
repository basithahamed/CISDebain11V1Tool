#!/bin/bash

# Function to check the audit_backlog_limit parameter
check_audit_backlog_limit() {
    local output=""
    local found_invalid_config=false

    while IFS= read -r line; do
        if ! grep -Pq 'audit_backlog_limit=\d+\b' <<< "$line"; then
            output+="$line\n"
            found_invalid_config=true
        fi
    done

    if ! "$found_invalid_config"; then
        output="audit_backlog_limit is set correctly in all grub.cfg files"
    fi

    echo -e "$output"
}

# Find and check audit_backlog_limit in all grub.cfg files
output=$(find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -Pv 'audit_backlog_limit=\d+\b')

if [ -z "$output" ]; then
    echo -e "4.1.1.4 Ensure audit_backlog_limit is sufficient - \e[32mPass\e[0m"
else
    echo -e "4.1.1.4 Ensure audit_backlog_limit is sufficient - \e[31mFail\e[0m"
    echo -e "\nReason(s) for audit failure:\n$output\n"
fi
