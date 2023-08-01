#!/usr/bin/env bash

# Function to check permissions on /etc/cron.weekly
check_cron_weekly_permissions() {
    local cron_weekly_permissions=$(stat -c "%A" /etc/cron.weekly)
    local cron_weekly_uid=$(stat -c "%U" /etc/cron.weekly)
    local cron_weekly_gid=$(stat -c "%G" /etc/cron.weekly)

    if [[ "$cron_weekly_permissions" == "drwx------" && "$cron_weekly_uid" == "root" && "$cron_weekly_gid" == "root" ]]; then
        echo -e "\n5.1.5 Ensure permissions on /etc/cron.weekly are configured --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.1.5 Ensure permissions on /etc/cron.weekly are configured --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check permissions on /etc/cron.weekly
check_cron_weekly_permissions
