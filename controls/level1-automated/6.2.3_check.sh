#!/bin/bash

# Check if all groups in /etc/passwd exist in /etc/group
check_groups_existence() {
    local passwd_groups=$(cut -s -d: -f4 /etc/passwd | sort -u)

    for group in $passwd_groups; do
        grep -q -P "^.*?:[^:]*:$group:" /etc/group
        if [ $? -ne 0 ]; then
            echo "Group $group is referenced by /etc/passwd but does not exist in /etc/group"
            return 1
        fi
    done

    return 0
}

# Call the function to check group existence
check_groups_existence
if [ $? -eq 0 ]; then
    echo -e "6.2.3 Ensure all groups in /etc/passwd exist in /etc/group --> \e[32mPASS\e[0m"
else
    echo -e "6.2.3 Ensure all groups in /etc/passwd exist in /etc/group --> \e[31mFAIL\e[0m"
fi
