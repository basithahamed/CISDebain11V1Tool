#!/bin/bash

# Function to check events that modify the system's network environment are collected
check_network_events() {
    local audit_rules_output
    audit_rules_output=$(awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b(32|64)/ \
    &&/ -S/ \
    &&(/sethostname/ \
    ||/setdomainname/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    if [ -n "$audit_rules_output" ]; then
        echo -e "\n4.1.3.5 Ensure events that modify the system's network environment are collected - \e[32mPass\e[0m"
        echo -e "\nResult:\n$audit_rules_output\n"
    else
        echo -e "\n4.1.3.5 Ensure events that modify the system's network environment are collected - \e[31mFail\e[0m"
    fi

    audit_rules_output=$(awk '/^ *-w/ \
    &&(/\/etc\/issue/ \
    ||/\/etc\/issue.net/ \
    ||/\/etc\/hosts/ \
    ||/\/etc\/network/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    if [ -n "$audit_rules_output" ]; then
        echo -e "\nResult:\n$audit_rules_output\n"
    else
        echo -e "\n4.1.3.5 Ensure events that modify the system's network environment are collected - \e[31mFail\e[0m"
    fi
}

# Call the function to check events that modify the system's network environment are collected
check_network_events
