#!/bin/bash

# Function to check on-disk configuration rules for login and logout events
check_on_disk_login_logout_rules() {
    local login_logout_rules

    # Check on-disk rules for login and logout events
    login_logout_rules=$(awk '/^ *-w/ \
    &&(/\/var\/log\/lastlog/ \
    ||/\/var\/run\/faillock/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Check if login_logout_rules is not empty
    if [ -n "$login_logout_rules" ]; then
        echo -e "\n4.1.3.12 Ensure login and logout events are collected --> \e[32mPass\e[0m\n"
        echo -e "On-disk configuration:\n$login_logout_rules\n"
    else
        echo -e "\n4.1.3.12 Ensure login and logout events are collected --> \e[31mFail\e[0m\n"
        echo -e "Reason: The audit rule for login and logout events is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for login and logout events
check_on_disk_login_logout_rules

# Check loaded rules for login and logout events
echo "Running configuration:"
loaded_login_logout_rules=$(auditctl -l | awk '/^ *-w/ \
&&(/\/var\/log\/lastlog/ \
||/\/var\/run\/faillock/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')
if [ -n "$loaded_login_logout_rules" ]; then
    echo "$loaded_login_logout_rules"
fi
