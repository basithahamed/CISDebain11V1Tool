#!/bin/bash

# Function to check the use of privileged commands is collected
check_privileged_commands() {
    # Check if auditd is installed
    if ! dpkg -l auditd &>/dev/null; then
        echo -e "\n4.1.3.6 Ensure use of privileged commands is collected - \e[31mfailed\e[0m"
        echo "auditd is not installed"
        exit 1
    fi

    local output=""
    local found=0
    for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
        for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
            if grep -qr "${PRIVILEGED}" /etc/audit/rules.d; then
                output+="OK: '${PRIVILEGED}' found in auditing rules.\n"
                found=1
            else
                output+="Warning: '${PRIVILEGED}' not found in on disk configuration.\n"
            fi
        done
    done

    if [ $found -eq 1 ]; then
        echo -e "\n4.1.3.6 Ensure use of privileged commands is collected - \e[32mpassed\e[0m"
        echo -e "$output"
    else
        echo -e "\n4.1.3.6 Ensure use of privileged commands is collected - \e[31mfailed\e[0m"
        echo "No privileged commands found in auditing rules."
    fi
}

# Call the function to check the use of privileged commands is collected
check_privileged_commands
