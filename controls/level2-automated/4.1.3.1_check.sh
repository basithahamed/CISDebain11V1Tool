#!/bin/bash

# Function to check changes to the system administration scope (sudoers)
check_sudoers_changes() {
    local audit_rules_output=$(awk '/^ *-w/ \
    &&/\/etc\/sudoers/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    if [ -n "$audit_rules_output" ]; then
        echo -e "\n4.1.3.1 Ensure changes to system administration scope (sudoers) is collected - \e[32mpassed\e[0m"
        echo -e "\nResult:\n$audit_rules_output\n"
    else
        echo -e "\n4.1.3.1 Ensure changes to system administration scope (sudoers) is collected - \e[31mfailed\e[0m"
    fi
}

# Call the function to check changes to system administration scope (sudoers)
check_sudoers_changes
