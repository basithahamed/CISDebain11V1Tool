#!/usr/bin/env bash

# Function to check permissions on /etc/crontab
check_crontab_permissions() {
    local crontab_permissions=$(stat -c "%A" /etc/crontab)
    local crontab_uid=$(stat -c "%U" /etc/crontab)
    local crontab_gid=$(stat -c "%G" /etc/crontab)

    if [[ "$crontab_permissions" == "rw-------" && "$crontab_uid" == "root" && "$crontab_gid" == "root" ]]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\e[31mfailed\e[0m"
    fi
}

# Call the function to check permissions on /etc/crontab
result=$(check_crontab_permissions)
echo  "\n5.1.2 Ensure permissions on /etc/crontab are configured --> $result"
