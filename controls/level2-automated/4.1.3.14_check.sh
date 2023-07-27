#!/bin/bash

# Function to check on-disk configuration rules for events that modify MAC
check_on_disk_mac_rules() {
    local mac_rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    # Check on-disk rules for MAC modification events
    mac_rules=$(awk "/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -F *auid>=${UID_MIN}/ \
    &&/ -S/ \
    &&(/\/etc\/apparmor/||/\/etc\/apparmor.d/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

    # Check if mac_rules is not empty
    if [ -n "$mac_rules" ]; then
        echo -e "\n4.1.3.14 Ensure events that modify the system's Mandatory Access Controls are collected --> \e[32mPass\e[0m\n"
        echo -e "On-disk configuration:\n$mac_rules\n"
    else
        echo -e "\n4.1.3.14 Ensure events that modify the system's Mandatory Access Controls are collected --> \e[31mFail\e[0m\n"
        echo -e "Reason: The audit rule for MAC modification events is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for MAC modification events
check_on_disk_mac_rules

# Check loaded rules for MAC modification events
echo "Running configuration:"
loaded_mac_rules=$(auditctl -l | awk "/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -F *auid>=${UID_MIN}/ \
&&/ -S/ \
&&(/\/etc\/apparmor/||/\/etc\/apparmor.d/) \
&&/ +-p *wa/ \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")
if [ -n "$loaded_mac_rules" ]; then
    echo "$loaded_mac_rules"
fi
