#!/bin/bash

# Function to audit SGID executables on a given partition
audit_sgid_executables() {
    local partition="$1"
    local sgid_files=$(find "$partition" -xdev -type f -perm -2000)

    if [ -z "$sgid_files" ]; then
        echo -e "\e[32mPASS\e[0m"
    else
        echo -e "\e[31mFAIL\e[0m"
        echo "SGID executables found:"
        echo "$sgid_files"
    fi
}

# Get a list of all local partitions
partitions=$(df --local -P | awk '{if (NR!=1) print $6}')

# Initialize a variable to track the overall result
overall_result="\e[32mPASS\e[0m"

# Check each partition for SGID executables
for partition in $partitions; do
    result=$(audit_sgid_executables "$partition")
    if [ "$result" == "FAIL" ]; then
        overall_result="FAIL"
    fi
done

# Print the final result
echo -e "6.1.13 Audit SGID executables --> $overall_result"
