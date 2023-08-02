#!/bin/bash

# Function to check if the running and on-disk audit configurations are the same
check_audit_config_consistency() {
    local on_disk_rules running_rules
    on_disk_rules=$(augenrules --print 2>/dev/null)
    running_rules=$(auditctl -l 2>/dev/null)

    # Check if both on-disk and running rules are not empty
    if [ -n "$on_disk_rules" ] && [ -n "$running_rules" ]; then
        if [ "$on_disk_rules" = "$running_rules" ]; then
            echo -e "\n4.1.3.21 Ensure the running and on-disk configuration is the same --> \e[32mpassed\e[0m\n"
            echo -e "On-disk configuration:\n$on_disk_rules\n"
            echo -e "Running configuration:\n$running_rules\n"
        else
            echo -e "\n4.1.3.21 Ensure the running and on-disk configuration is the same --> \e[31mfailed\e[0m\n"
            echo -e "Reason: The running and on-disk audit configurations are not the same.\n"
        fi
    else
        echo -e "\n4.1.3.21 Ensure the running and on-disk configuration is the same --> \e[31mfailed\e[0m\n"
        echo -e "Reason: Unable to retrieve audit rules. Please check if the audit daemon is running and rules are loaded.\n"
    fi
}

# Check if the running and on-disk audit configurations are the same
check_audit_config_consistency
