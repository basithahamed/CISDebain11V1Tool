#!/usr/bin/env bash

# Function to check permissions on /etc/cron.d
check_cron_d_permissions() {
    local cron_d_permissions=$(stat -c "%A" /etc/cron.d)
    local cron_d_uid=$(stat -c "%U" /etc/cron.d)
    local cron_d_gid=$(stat -c "%G" /etc/cron.d)

    if [[ "$cron_d_permissions" == "drwx------" && "$cron_d_uid" == "root" && "$cron_d_gid" == "root" ]]; then
        echo -e "\n5.1.7 Ensure permissions on /etc/cron.d are configured --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.1.7 Ensure permissions on /etc/cron.d are configured --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check permissions on /etc/cron.d
check_cron_d_permissions
