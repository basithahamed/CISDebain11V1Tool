#!/bin/bash

# Function to audit SUID executables on a given partition
audit_suid_executables() {
    local partition="$1"
    local suid_files=$(find "$partition" -xdev -type f -perm -4000)

    if [ -z "$suid_files" ]; then
        echo -e "\e[32mPASS\e[0m"
    else
        echo -e "\e[31mFAIL\e[0m"
        echo "SUID executables found:"
        echo "$suid_files"
    fi
}

# Get a list of all local partitions
partitions=$(df --local -P | awk '{if (NR!=1) print $6}')

# Initialize a variable to track the overall result
overall_result="\e[32mPASS\e[0m"

# Check each partition for SUID executables
for partition in $partitions; do
    result=$(audit_suid_executables "$partition")
    if [ "$result" == "FAIL" ]; then
        overall_result="FAIL"
    fi
done

# Print the final result
echo -e "6.1.12 Audit SUID executables --> $overall_result"
