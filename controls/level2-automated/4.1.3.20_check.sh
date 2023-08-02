#!/bin/bash

# Function to check if the audit configuration is immutable
check_audit_immutable() {
    local audit_immutable_rule
    audit_immutable_rule=$(grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules | tail -1)

    # Check if audit_immutable_rule is not empty
    if [ -n "$audit_immutable_rule" ]; then
        echo -e "\n4.1.3.20 Ensure the audit configuration is immutable --> \e[32mpassed\e[0m\n"
        echo -e "On-disk configuration:\n$audit_immutable_rule\n"
    else
        echo -e "\n4.1.3.20 Ensure the audit configuration is immutable --> \e[31mfailed\e[0m\n"
        echo -e "Reason: The audit configuration is not set to be immutable.\n"
    fi
}

# Check if the audit configuration is immutable
check_audit_immutable
