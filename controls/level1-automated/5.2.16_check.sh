#!/usr/bin/env bash

# Function to check if SSH AllowTcpForwarding is disabled
check_ssh_allow_tcp_forwarding_disabled() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "allowtcpforwarding")

    if echo "$sshd_output" | grep -qi "allowtcpforwarding\s+no"; then
        echo -e "\n5.2.16 Ensure SSH AllowTcpForwarding is disabled --> \e[32mPASS\e[0m\n"
    else
        echo -e "\n5.2.16 Ensure SSH AllowTcpForwarding is disabled --> \e[31mFAIL\e[0m\n"
    fi
}

# Call the function to check if SSH AllowTcpForwarding is disabled
check_ssh_allow_tcp_forwarding_disabled
