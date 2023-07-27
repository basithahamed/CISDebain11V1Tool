#!/bin/bash

# Function to check on-disk configuration rules for successful file system mounts
check_on_disk_mount_rules() {
    local output=""
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    if [ -n "${UID_MIN}" ]; then
        if awk "/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -S/ \
&&/mount/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules | grep -q mounts; then
            output+="\n4.1.3.10 Ensure successful file system mounts are collected --> \e[32mPass\e[0m\n"
        else
            output+="\n4.1.3.10 Ensure successful file system mounts are collected --> \e[31mFail\e[0m\n"
            output+="Reason: The audit rule for successful file system mounts is not found or is incorrect.\n"
        fi
    else
        output+="\n4.1.3.10 Ensure successful file system mounts are collected --> \e[31mFail\e[0m\n"
        output+="Reason: Variable 'UID_MIN' is unset.\n"
    fi

    echo -e "$output"
}

# Call the function to check on-disk configuration rules for successful file system mounts
result=$(check_on_disk_mount_rules)

if [ -n "$result" ]; then
    echo -e "$result"
fi
