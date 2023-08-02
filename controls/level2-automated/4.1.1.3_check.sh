#!/usr/bin/env bash

check_prior_auditd() {
    local result=$(find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -v 'audit=1')

    if [ -z "$result" ]; then
        echo -e "4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled - \e[32mpassed\e[0m"
    else
        echo -e "4.1.1.3 Ensure auditing for processes that start prior to auditd is enabled - \e[31mfailed\e[0m"
        echo -e "\nAudit configuration allows processes to start prior to auditd.\n"
    fi
}

# Call the function to check auditing for processes that start prior to auditd
check_prior_auditd
