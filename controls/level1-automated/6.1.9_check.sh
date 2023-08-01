#!/bin/bash

# Function to check for world-writable files on a given partition
check_partition_for_world_writable_files() {
    local partition="$1"
    local world_writable_files=$(find "$partition" -xdev -type f -perm -0002)

    if [ -z "$world_writable_files" ]; then
        echo "PASS"
    else
        echo "FAIL"
    fi
}

# Get a list of all local partitions
partitions=$(df --local -P | awk '{if (NR!=1) print $6}')

# Initialize a variable to track the overall result
overall_result="\e[32mPASS\e[0m"

# Check each partition for world-writable files
for partition in $partitions; do
    result=$(check_partition_for_world_writable_files "$partition")
    if [ "$result" == "FAIL" ]; then
        overall_result="\e[31mFAIL\e[0m"
    fi
done

# Print the final result
echo -e "6.1.9 Ensure no world writable files exist --> $overall_result"
