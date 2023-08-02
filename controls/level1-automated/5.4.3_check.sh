#!/bin/bash

# Function to print the result in the correct format
print_result() {
    local status=$1
    local message=$2

    if [ "$status" == "fail" ]; then
        echo -e "$message --> \e[31mfailed\e[0m"
    else
        echo -e "$message --> \033[0;32mpassed\033[0m"
    fi
}

# Function to check if the configuration line exists in the file and contains the expected value
check_config_in_file() {
    local config_file=$1
    local config_regex=$2
    local expected_value=$3

    grep -P -q "$config_regex" "$config_file"
    if [ $? -eq 0 ]; then
        local actual_value=$(grep -P "$config_regex" "$config_file" | awk '{print $NF}')
        if [ "$actual_value" -ge "$expected_value" ]; then
            echo "pass"
        else
            echo "fail"
        fi
    else
        echo "fail"
    fi
}

# Check password reuse limit
result=$(check_config_in_file "/etc/pam.d/common-password" "^\h*password\h+([^#\n\r]+\h+)?pam_pwhistory\.so\h+([^#\n\r]+\h+)?remember=([5-9]|[1-9][0-9]+)\b" "5")

# Print the result
print_result "$result" "5.4.3 Ensure password reuse is limited"
