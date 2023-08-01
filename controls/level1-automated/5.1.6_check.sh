#!/usr/bin/env bash

# Function to check permissions on /etc/cron.monthly
check_cron_monthly_permissions() {
    local cron_monthly_permissions=$(stat -c "%A" /etc/cron.monthly)
    local cron_monthly_uid=$(stat -c "%U" /etc/cron.monthly)
    local cron_monthly_gid=$(stat -c "%G" /etc/cron.monthly)

    if [[ "$cron_monthly_permissions" == "drwx------" && "$cron_monthly_uid" == "root" && "$cron_monthly_gid" == "root" ]]; then
        echo -e "\n5.1.6 Ensure permissions on /etc/cron.monthly are configured --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.1.6 Ensure permissions on /etc/cron.monthly are configured --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check permissions on /etc/cron.monthly
check_cron_monthly_permissions
