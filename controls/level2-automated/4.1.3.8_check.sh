#!/bin/bash

# Function to check events that modify user/group information are collected
check_modify_user_group_info_events() {
    local output=""
    local found=0
    for RULE_FILE in /etc/audit/rules.d/*.rules; do
        if grep -q -E '^-w *(\/etc\/group|\/etc\/passwd|\/etc\/gshadow|\/etc\/shadow|\/etc\/security\/opasswd) *-p *wa *(-k *identity| *-F *key=)' "$RULE_FILE"; then
            output+="$(grep -E '^-w *(\/etc\/group|\/etc\/passwd|\/etc\/gshadow|\/etc\/shadow|\/etc\/security\/opasswd) *-p *wa *(-k *identity| *-F *key=)' "$RULE_FILE")\n"
            found=1
        fi
    done

    if [ $found -eq 1 ]; then
        echo -e "\n4.1.3.8 Ensure events that modify user/group information are collected - \e[32mPass\e[0m"
        echo -e "Verify the output matches:\n$output"
    else
        echo -e "\n4.1.3.8 Ensure events that modify user/group information are collected - \e[31mFail\e[0m"
        echo "No matching rules found in audit rules."
    fi
}

# Call the function to check events that modify user/group information are collected
check_modify_user_group_info_events
