#!/usr/bin/env bash

# Function to check if SSH PermitUserEnvironment is disabled
check_ssh_permit_user_environment_disabled() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i 'permituserenvironment no')
    sshd_config_output=$(grep -Ei '^\s*PermitUserEnvironment\s+yes' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] && [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.10 Ensure SSH PermitUserEnvironment is disabled --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.10 Ensure SSH PermitUserEnvironment is disabled --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH PermitUserEnvironment is disabled
check_ssh_permit_user_environment_disabled
