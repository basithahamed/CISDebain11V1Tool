#!/bin/bash

# Check for duplicate user names
check_duplicate_user_names() {
    cut -d: -f1 /etc/passwd | sort | uniq -d | while read -r x; do
        echo "Duplicate login name $x in /etc/passwd"
    done
}

# Call the function to check for duplicate user names
result=$(check_duplicate_user_names)

# Check if the result is empty
if [ -z "$result" ]; then
    echo -e "6.2.7 Ensure no duplicate user names exist --> \033[0;32mpassed\033[0m"
else
    echo -e "6.2.7 Ensure no duplicate user names exist --> \e[31mfailed\e[0m"
fi
