#!/usr/bin/env bash

# Function to check if /etc/cron.deny exists and permissions on /etc/cron.allow
check_cron_restrictions() {
    # Check if /etc/cron.deny exists
    if [ ! -f "/etc/cron.deny" ]; then
        deny_status="PASS"
    else
        deny_status="FAIL"
    fi

    # Check permissions on /etc/cron.allow
    local cron_allow_permissions=$(stat -c "%A" /etc/cron.allow)
    local cron_allow_uid=$(stat -c "%U" /etc/cron.allow)
    local cron_allow_gid=$(stat -c "%G" /etc/cron.allow)

    if [[ "$cron_allow_permissions" == "-rw-r-----" && "$cron_allow_uid" == "root" && "$cron_allow_gid" == "root" ]]; then
        allow_status="PASS"
    else
        allow_status="FAIL"
    fi

    # Check if both conditions are pass, then show as PASS, otherwise show as FAIL in red color
    if [[ "$deny_status" == "PASS" && "$allow_status" == "PASS" ]]; then
        echo -e "\n5.1.8 Ensure cron is restricted to authorized users --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.1.8 Ensure cron is restricted to authorized users --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if /etc/cron.deny exists and permissions on /etc/cron.allow
check_cron_restrictions
