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

# Check password hashing algorithm in /etc/pam.d/common-password
pam_common_password_output=$(grep -v ^# /etc/pam.d/common-password | grep -E "(yescrypt|md5|bigcrypt|sha256|sha512|blowfish)")

# Check password hashing algorithm in /etc/login.defs
login_defs_output=$(grep -i "^\s*ENCRYPT_METHOD\s*yescrypt\s*$" /etc/login.defs)

# Print the results
if [ -z "$pam_common_password_output" ] && [ "$login_defs_output" == "ENCRYPT_METHOD yescrypt" ]; then
    print_result "pass" "5.4.4 Ensure password hashing algorithm is up to date with the latest standards"
else
    print_result "fail" "5.4.4 Ensure password hashing algorithm is up to date with the latest standards"
fi
