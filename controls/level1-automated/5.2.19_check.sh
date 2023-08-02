#!/usr/bin/env bash

# Function to check if SSH MaxStartups is configured with the appropriate value
check_ssh_max_startups() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i maxstartups)
    sshd_config_output=$(grep -Ei '^\s*maxstartups\s+(((1[1-9]|[1-9][0-9][0-9]+):([0-9]+):([0-9]+))|(([0-9]+):(3[1-9]|[4-9][0-9]|[1-9][0-9][0-9]+):([0-9]+))|(([0-9]+):([0-9]+):(6[1-9]|[7-9][0-9]|[1-9][0-9][0-9]+)))' /etc/ssh/sshd_config)

    if echo "$sshd_output" | grep -qi "maxstartups 10:30:60" && [ -z "$sshd_config_output" ]; then
        echo -e "\n5.2.19 Ensure SSH MaxStartups is configured --> \033[0;32mpassed\033[0m"
    else
        echo -e "\n5.2.19 Ensure SSH MaxStartups is configured --> \e[31mfailed\e[0m\n"
    fi
}

# Call the function to check if SSH MaxStartups is configured with the appropriate value
check_ssh_max_startups
