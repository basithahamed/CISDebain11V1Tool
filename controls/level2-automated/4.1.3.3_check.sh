#!/bin/bash

# Function to check events that modify the sudo log file are collected
check_sudo_log_modification() {
    SUDO_LOG_FILE_ESCAPED=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g' -e 's|/|\\/|g')

    if [ -n "${SUDO_LOG_FILE_ESCAPED}" ]; then
        local audit_rules_output=$(awk "/^ *-w/ \
        &&/""${SUDO_LOG_FILE_ESCAPED}""/ \
        &&/ +-p *wa/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

        if [ -n "$audit_rules_output" ]; then
            echo -e "\n4.1.3.3 Ensure events that modify the sudo log file are collected - \e[32mPass\e[0m"
            echo -e "\nResult:\n$audit_rules_output\n"
        else
            echo -e "\n4.1.3.3 Ensure events that modify the sudo log file are collected - \e[31mFail\e[0m"
        fi
    else
        echo -e "\n4.1.3.3 Ensure events that modify the sudo log file are collected - \e[31mFail\e[0m"
        echo "ERROR: Variable 'SUDO_LOG_FILE_ESCAPED' is unset."
    fi
}

# Call the function to check events that modify the sudo log file are collected
check_sudo_log_modification
