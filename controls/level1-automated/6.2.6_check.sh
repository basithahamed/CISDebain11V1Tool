#!/bin/bash

# Check for duplicate GIDs
check_duplicate_gids() {
    cut -d: -f3 /etc/group | sort | uniq -d | while read x ; do
        echo "Duplicate GID ($x) in /etc/group"
    done
}

# Call the function to check for duplicate GIDs
result=$(check_duplicate_gids)

# Check if the result is empty
if [ -z "$result" ]; then
    echo -e "6.2.6 Ensure no duplicate GIDs exist --> \e[32mPASS\e[0m"
else
    echo -e "6.2.6 Ensure no duplicate GIDs exist --> \e[31mFAIL\e[0m"
fi
