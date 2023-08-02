#!/usr/bin/env bash

# Function to check if only strong ciphers are used in SSH
check_strong_ciphers_used() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i 'ciphers')
    weak_ciphers=("3des-cbc" "aes128-cbc" "aes192-cbc" "aes256-cbc")

    for cipher in "${weak_ciphers[@]}"; do
        if echo "$sshd_output" | grep -qi "$cipher"; then
            echo -e "\n5.2.13 Ensure only strong Ciphers are used --> \e[31mfailed\e[0m\n"
            return
        fi
    done

    echo -e "\n5.2.13 Ensure only strong Ciphers are used --> \033[0;32mpassed\033[0m"
}

# Call the function to check if only strong ciphers are used in SSH
check_strong_ciphers_used
