#!/usr/bin/env bash

# Function to check if only strong MAC algorithms are used in SSH
check_strong_mac_algorithms_used() {
    sshd_output=$(sshd -T -C user=root -C host="$(hostname)" -C addr="$(grep $(hostname) /etc/hosts | awk '{print $1}')" | grep -i "MACs")
    weak_mac_algorithms=("hmac-md5" "hmac-md5-96" "hmac-ripemd160" "hmac-sha1" "hmac-sha1-96" "umac-64@openssh.com" "umac-128@openssh.com" "hmac-md5-etm@openssh.com" "hmac-md5-96-etm@openssh.com" "hmac-ripemd160-etm@openssh.com" "hmac-sha1-etm@openssh.com" "hmac-sha1-96-etm@openssh.com" "umac-64-etm@openssh.com" "umac-128-etm@openssh.com")

    for mac_algorithm in "${weak_mac_algorithms[@]}"; do
        if echo "$sshd_output" | grep -qi "$mac_algorithm"; then
            echo -e "\n5.2.14 Ensure only strong MAC algorithms are used --> \e[31mfailed\e[0m\n"
            return
        fi
    done

    echo -e "\n5.2.14 Ensure only strong MAC algorithms are used --> \033[0;32mpassed\033[0m"
}

# Call the function to check if only strong MAC algorithms are used in SSH
check_strong_mac_algorithms_used
