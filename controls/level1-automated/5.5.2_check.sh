#!/bin/bash

# Function to check if the given user is a system account
is_system_account() {
    local user="$1"
    awk -F: '$1!~/(root|sync|shutdown|halt|^\+)/ && $3<'"$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"' && $7!~/((\/usr)?\/sbin\/nologin)/ && $7!~/(\/bin)?\/false/ {print}' /etc/passwd | grep -q "^$user:"
}

# Function to check if the given user account is locked
is_account_locked() {
    local user="$1"
    passwd -S "$user" | awk '($2!~/LK?/) {print}' | grep -q "^$user "
}

# Check system accounts
all_pass=true
while IFS=: read -r user _ uid _ _ _ shell; do
    if ! is_system_account "$user"; then
        all_pass=false
        break
    else
        if is_account_locked "$user"; then
            all_pass=false
            break
        fi
    fi
done < /etc/passwd

# Color codes for pass and fail
PASS_COLOR="\033[0;32m"
FAIL_COLOR="\033[0;31m"
RESET_COLOR="\033[0m"

if [ "$all_pass" = true ]; then
    echo -e "5.5.2 Ensure system accounts are secured --> ${PASS_COLOR}pass${RESET_COLOR}"
else
    echo -e "5.5.2 Ensure system accounts are secured --> ${FAIL_COLOR}fail${RESET_COLOR}"
fi
