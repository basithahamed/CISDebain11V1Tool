#!/bin/bash

# Function to check actions as another user being always logged
check_actions_as_another_user() {
    local audit_rules_output=$(awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&(/ -C *euid!=uid/||/ -C *uid!=euid/) \
    &&/ -S *execve/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    if [ -n "$audit_rules_output" ]; then
        echo -e "\n4.1.3.2 Ensure actions as another user are always logged - \e[32mpassed\e[0m"
        echo -e "\nResult:\n$audit_rules_output\n"
    else
        echo -e "\n4.1.3.2 Ensure actions as another user are always logged - \e[31mfailed\e[0m"
    fi
}

# Call the function to check actions as another user being always logged
check_actions_as_another_user
