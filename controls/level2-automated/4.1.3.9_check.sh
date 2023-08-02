#!/bin/bash

# Function to check discretionary access control permission modification events are collected
check_dac_permission_mod_events() {
    local output=""
    local found=0
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    if [ -n "${UID_MIN}" ]; then
        for RULE_FILE in /etc/audit/rules.d/*.rules; do
            if grep -q -E "^-a *always,exit *-F *arch=b[2346]{2} *-S *(chmod|fchmod|fchmodat|chown|fchown|lchown|fchownat|setxattr|lsetxattr|fsetxattr|removexattr|lremovexattr|fremovexattr) *-F *auid>=${UID_MIN} *-F *auid!=unset *(-F *key=perm_mod| *-k *perm_mod)" "$RULE_FILE"; then
                output+="$(grep -E "^-a *always,exit *-F *arch=b[2346]{2} *-S *(chmod|fchmod|fchmodat|chown|fchown|lchown|fchownat|setxattr|lsetxattr|fsetxattr|removexattr|lremovexattr|fremovexattr) *-F *auid>=${UID_MIN} *-F *auid!=unset *(-F *key=perm_mod| *-k *perm_mod)" "$RULE_FILE")\n"
                found=1
            fi
        done

        if [ $found -eq 1 ]; then
            echo -e "\n4.1.3.9 Ensure discretionary access control permission modification events are collected - \e[32mpassed\e[0m"
            echo -e "Verify the output matches:\n$output"
        else
            echo -e "\n4.1.3.9 Ensure discretionary access control permission modification events are collected - \e[31mfailed\e[0m"
            echo "No matching rules found in audit rules."
        fi
    else
        echo -e "\n4.1.3.9 Ensure discretionary access control permission modification events are collected - \e[31mfailed\e[0m"
        echo "ERROR: Variable 'UID_MIN' is unset."
    fi
}

# Call the function to check discretionary access control permission modification events
check_dac_permission_mod_events
