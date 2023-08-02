#!/bin/bash

# Check for duplicate UIDs
check_duplicate_uids() {
    cut -f3 -d":" /etc/passwd | sort -n | uniq -c | while read x ; do
        [ -z "$x" ] && break
        set - $x
        if [ $1 -gt 1 ]; then
            users=$(awk -F: '($3 == n) { print $1 }' n=$2 /etc/passwd | xargs)
            echo "Duplicate UID ($2): $users"
        fi
    done
}

# Call the function to check for duplicate UIDs
result=$(check_duplicate_uids)

# Check if the result is empty
if [ -z "$result" ]; then
    echo -e "6.2.5 Ensure no duplicate UIDs exist --> \033[0;32mpassed\033[0m"
else
    echo -e "6.2.5 Ensure no duplicate UIDs exist --> \e[31mfailed\e[0m"
fi
