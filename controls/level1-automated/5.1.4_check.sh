#!/usr/bin/env bash

# Function to check permissions on /etc/cron.daily
check_cron_daily_permissions() {
    local cron_daily_permissions=$(stat -c "%A" /etc/cron.daily)
    local cron_daily_uid=$(stat -c "%U" /etc/cron.daily)
    local cron_daily_gid=$(stat -c "%G" /etc/cron.daily)

    if [[ "$cron_daily_permissions" == "drwx------" && "$cron_daily_uid" == "root" && "$cron_daily_gid" == "root" ]]; then
        echo -e "\n5.1.4 Ensure permissions on /etc/cron.daily are configured --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.1.4 Ensure permissions on /etc/cron.daily are configured --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check permissions on /etc/cron.daily
check_cron_daily_permissions
