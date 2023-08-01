#!/bin/bash

# Check for duplicate group names
check_duplicate_group_names() {
    cut -d: -f1 /etc/group | sort | uniq -d | while read -r x; do
        echo "Duplicate group name $x in /etc/group"
    done
}

# Call the function to check for duplicate group names
result=$(check_duplicate_group_names)

# Check if the result is empty
if [ -z "$result" ]; then
    echo -e "6.2.8 Ensure no duplicate group names exist --> \e[32mPASS\e[0m"
else
    echo -e "6.2.8 Ensure no duplicate group names exist --> \e[31mFAIL\e[0m"
fi
