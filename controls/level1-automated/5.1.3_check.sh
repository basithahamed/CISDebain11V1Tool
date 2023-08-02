#!/usr/bin/env bash

# Function to check permissions on /etc/cron.hourly
check_cron_hourly_permissions() {
    local cron_hourly_permissions=$(stat -c "%A" /etc/cron.hourly)
    local cron_hourly_uid=$(stat -c "%U" /etc/cron.hourly)
    local cron_hourly_gid=$(stat -c "%G" /etc/cron.hourly)

    if [[ "$cron_hourly_permissions" == "drwx------" && "$cron_hourly_uid" == "root" && "$cron_hourly_gid" == "root" ]]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\e[31mfailed\e[0m"
    fi
}

# Call the function to check permissions on /etc/cron.hourly
result=$(check_cron_hourly_permissions)
echo -e "\n5.1.3 Ensure permissions on /etc/cron.hourly are configured --> $result\n"
