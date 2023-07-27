#!/bin/bash

# Function to check on-disk configuration rules for session initiation information
check_on_disk_session_rules() {
    local session_rules

    # Check on-disk rules for session initiation information
    session_rules=$(awk '/^ *-w/ \
    &&(/\/var\/run\/utmp/ \
    ||/\/var\/log\/wtmp/ \
    ||/\/var\/log\/btmp/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Check if session_rules is not empty
    if [ -n "$session_rules" ]; then
        echo -e "\n4.1.3.11 Ensure session initiation information is collected --> \e[32mPass\e[0m\n"
        echo -e "On-disk configuration:\n$session_rules\n"
    else
        echo -e "\n4.1.3.11 Ensure session initiation information is collected --> \e[31mFail\e[0m\n"
        echo -e "Reason: The audit rule for session initiation information is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for session initiation information
check_on_disk_session_rules

# Check loaded rules for session initiation information
echo "Running configuration:"
loaded_session_rules=$(auditctl -l | awk '/^ *-w/ \
&&(/\/var\/run\/utmp/ \
||/\/var\/log\/wtmp/ \
||/\/var\/log\/btmp/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')
if [ -n "$loaded_session_rules" ]; then
    echo "$loaded_session_rules"
fi
