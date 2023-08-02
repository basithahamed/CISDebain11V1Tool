#!/bin/bash

# Function to check events that modify date and time information are collected
check_time_change_events() {
    local audit_rules_output
    audit_rules_output=$(awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&/ -S/ \
    &&(/adjtimex/ \
    ||/settimeofday/ \
    ||/clock_settime/ ) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    if [ -n "$audit_rules_output" ]; then
        echo -e "\n4.1.3.4 Ensure events that modify date and time information are collected - \e[32mpassed\e[0m"
        echo -e "\nResult:\n$audit_rules_output\n"
    else
        echo -e "\n4.1.3.4 Ensure events that modify date and time information are collected - \e[31mfailed\e[0m"
    fi

    audit_rules_output=$(awk '/^ *-w/ \
    &&/\/etc\/localtime/ \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # if [ -n "$audit_rules_output" ]; then
    #     echo -e "\nResult:\n$audit_rules_output\n"
    # else
    #     echo -e "\n4.1.3.4 Ensure events that modify date and time information are collected - \e[31mfailed\e[0m"
    # fi
}

# Call the function to check events that modify date and time information are collected
check_time_change_events
