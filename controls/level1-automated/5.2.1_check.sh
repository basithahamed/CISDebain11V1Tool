#!/usr/bin/env bash

# Function to check permissions on /etc/ssh/sshd_config
check_sshd_config_permissions() {
    local sshd_config_permissions=$(stat -c "%A" /etc/ssh/sshd_config)
    local sshd_config_uid=$(stat -c "%U" /etc/ssh/sshd_config)
    local sshd_config_gid=$(stat -c "%G" /etc/ssh/sshd_config)

    if [[ "$sshd_config_permissions" == "-rw-------" && "$sshd_config_uid" == "root" && "$sshd_config_gid" == "root" ]]; then
        echo -e "5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured --> \033[0;32mpassed\033[0m"
    else
        echo -e "5.2.1 Ensure permissions on /etc/ssh/sshd_config are configured --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check permissions on /etc/ssh/sshd_config
check_sshd_config_permissions
