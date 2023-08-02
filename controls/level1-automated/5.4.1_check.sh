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

# Variables to track the check results
password_length_result="fail"
password_complexity_option1_result="fail"
password_complexity_option2_result="fail"

# Check password length
check_password_length() {
    local minlen=$(grep '^\s*minlen\s*' /etc/security/pwquality.conf | awk '{print $3}')
    if [[ -n "$minlen" && "$minlen" -eq 14 ]]; then
        password_length_result="pass"
    fi
}

# Check password complexity option 1
check_password_complexity_option1() {
    local minclass=$(grep '^\s*minclass\s*' /etc/security/pwquality.conf | awk '{print $3}')
    if [[ -n "$minclass" && "$minclass" -eq 4 ]]; then
        password_complexity_option1_result="pass"
    fi
}

# Check password complexity option 2
check_password_complexity_option2() {
    local dcredit=$(grep -E '^\s*[duol]credit\s*' /etc/security/pwquality.conf | awk '{print $3}')
    local ucredit=$(grep -E '^\s*ucredit\s*' /etc/security/pwquality.conf | awk '{print $3}')
    local lcredit=$(grep -E '^\s*lcredit\s*' /etc/security/pwquality.conf | awk '{print $3}')
    local ocredit=$(grep -E '^\s*ocredit\s*' /etc/security/pwquality.conf | awk '{print $3}')
    
    if [[ -n "$dcredit" && "$dcredit" -eq -1 && -n "$ucredit" && "$ucredit" -eq -1 && -n "$lcredit" && "$lcredit" -eq -1 && -n "$ocredit" && "$ocredit" -eq -1 ]]; then
        password_complexity_option2_result="pass"
    fi
}

# Call the functions to check password length and complexity
check_password_length
check_password_complexity_option1
check_password_complexity_option2

# Determine the overall result
if [ "$password_length_result" == "pass" ] && [ "$password_complexity_option1_result" == "pass" ] && [ "$password_complexity_option2_result" == "pass" ]; then
    print_result "pass" "5.4.1 Ensure password creation requirements are configured"
else
    print_result "fail" "5.4.1 Ensure password creation requirements are configured"
fi
