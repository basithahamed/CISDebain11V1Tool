#!/usr/bin/env bash

# Function to check if only strong Key Exchange algorithms are used in SSH
check_strong_kex_algorithms_used() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "kexalgorithms")
    weak_kex_algorithms=("diffie-hellman-group1-sha1" "diffie-hellman-group14-sha1" "diffie-hellman-group-exchange-sha1")

    for kex_algorithm in "${weak_kex_algorithms[@]}"; do
        if echo "$sshd_output" | grep -qi "$kex_algorithm"; then
            echo -e "\n5.2.15 Ensure only strong Key Exchange algorithms are used --> \e[31mfailed\e[0m\n"
            return
        fi
    done

    echo -e "\n5.2.15 Ensure only strong Key Exchange algorithms are used --> \033[0;32mpassed\033[0m"
}

# Call the function to check if only strong Key Exchange algorithms are used in SSH
check_strong_kex_algorithms_used
