#!/bin/bash

# Function to check for unowned files or directories on a given partition
check_partition_for_unowned_files() {
    local partition="$1"
    local unowned_files=$(find "$partition" -xdev -nouser)

    if [ -z "$unowned_files" ]; then
        echo -e "\033[0;32mpassed\033[0m"
    else
        echo -e "\e[31mfailed\e[0m"
    fi
}

# Get a list of all local partitions
partitions=$(df --local -P | awk '{if (NR!=1) print $6}')

# Initialize a variable to track the overall result
overall_result="\033[0;32mpassed\033[0m"

# Check each partition for unowned files or directories
for partition in $partitions; do
    result=$(check_partition_for_unowned_files "$partition")
    if [ "$result" == "FAIL" ]; then
        overall_result="FAIL"
    fi
done

# Print the final result
echo -e "6.1.10 Ensure no unowned files or directories exist --> $overall_result"
