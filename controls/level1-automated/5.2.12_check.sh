#!/usr/bin/env bash

# Function to check if SSH X11 forwarding is disabled
check_ssh_x11_forwarding_disabled() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i 'x11forwarding no')
    sshd_config_output=$(grep -Ei '^\s*X11Forwarding\s+yes\b' /etc/ssh/sshd_config)

    if [ -n "$sshd_output" ] && [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.12 Ensure SSH X11 forwarding is disabled --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.12 Ensure SSH X11 forwarding is disabled --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH X11 forwarding is disabled
check_ssh_x11_forwarding_disabled
