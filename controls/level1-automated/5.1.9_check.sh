#!/usr/bin/env bash

# Function to check if /etc/at.deny exists and permissions on /etc/at.allow
check_at_restrictions() {
    # Check if /etc/at.deny exists
    if [ ! -f "/etc/at.deny" ]; then
        deny_status="PASS"
    else
        deny_status="FAIL"
    fi

    # Check permissions on /etc/at.allow
    local at_allow_permissions=$(stat -c "%A" /etc/at.allow)
    local at_allow_uid=$(stat -c "%U" /etc/at.allow)
    local at_allow_gid=$(stat -c "%G" /etc/at.allow)

    if [[ "$at_allow_permissions" == "-rw-r-----" && "$at_allow_uid" == "root" && "$at_allow_gid" == "root" ]]; then
        allow_status="PASS"
    else
        allow_status="FAIL"
    fi

    # Check if both conditions are pass, then show as PASS, otherwise show as FAIL in red color
    if [[ "$deny_status" == "PASS" && "$allow_status" == "PASS" ]]; then
        echo -e "\n5.1.9 Ensure at is restricted to authorized users --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.1.9 Ensure at is restricted to authorized users --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if /etc/at.deny exists and permissions on /etc/at.allow
check_at_restrictions
