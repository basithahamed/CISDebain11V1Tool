#!/bin/bash

# Function to print the result in the correct format
print_result() {
    local status=$1
    local message=$2

    if [ "$status" == "fail" ]; then
        echo -e "$message --> \e[31mFail\e[0m"
    else
        echo -e "$message --> \e[32mPass\e[0m"
    fi
}

# Function to check if a configuration line exists in a file
check_config_in_file() {
    local config_file=$1
    local config_param=$2
    grep -q "$config_param" "$config_file"
    if [ $? -eq 0 ]; then
        echo "pass"
    else
        echo "fail"
    fi
}

# Function to check if a specific value is configured in a file
check_value_in_file() {
    local config_file=$1
    local config_param=$2
    local expected_value=$3
    local actual_value=$(awk -F '=' "/^ *$config_param *=/ {print \$2}" "$config_file" | tr -d ' ')
    
    if [ -n "$actual_value" ]; then
        if [ "$config_param" == "deny" ] && [ "$actual_value" -le 4 ]; then
            echo "pass"
        elif [ "$config_param" == "fail_interval" ] && [ "$actual_value" -le 900 ]; then
            echo "pass"
        elif [ "$config_param" == "unlock_time" ] && ([ "$actual_value" -eq 0 ] || [ "$actual_value" -ge 600 ]); then
            echo "pass"
        else
            echo "fail"
        fi
    else
        echo "fail"
    fi
}

# Variables to track the check results
pam_faillock_common_auth_result=$(check_config_in_file "/etc/pam.d/common-auth" "pam_faillock.so")
pam_faillock_common_account_result=$(check_config_in_file "/etc/pam.d/common-account" "pam_faillock.so")
deny_result=$(check_value_in_file "/etc/security/faillock.conf" "deny" "4")
fail_interval_result=$(check_value_in_file "/etc/security/faillock.conf" "fail_interval" "900")
unlock_time_result=$(check_value_in_file "/etc/security/faillock.conf" "unlock_time" "600")

# Determine the overall result
overall_result="pass"

if [ "$pam_faillock_common_auth_result" == "fail" ] || [ "$pam_faillock_common_account_result" == "fail" ] || \
   [ "$deny_result" == "fail" ] || [ "$fail_interval_result" == "fail" ] || [ "$unlock_time_result" == "fail" ]; then
    overall_result="fail"
fi

# Print the results
print_result "$overall_result" "5.4.2 Ensure lockout for failed password attempts is configured"

# if [ "$overall_result" == "pass" ]; then
#     echo -e "  Common auth --> \e[32mPass\e[0m"
#     echo -e "  Common account --> \e[32mPass\e[0m"
#     echo -e "  Fail lock configuration --> \e[32mPass\e[0m"
# else
#     echo -e "  Common auth --> \e[31mFail\e[0m"
#     echo -e "  Common account --> \e[31mFail\e[0m"
#     echo -e "  Fail lock configuration --> \e[31mFail\e[0m"
# fi
