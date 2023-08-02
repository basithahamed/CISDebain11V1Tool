#!/bin/bash

# Function to check on-disk configuration rules for kernel module events
check_on_disk_kernel_module_rules() {
    local kernel_module_rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

    # Check on-disk rules for kernel module events
    kernel_module_rules=$(awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b[2346]{2}/ \
    &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
    &&/ -S/ \
    &&(/init_module/ \
    ||/finit_module/ \
    ||/delete_module/ \
    ||/create_module/ \
    ||/query_module/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Check if kernel_module_rules is not empty
    if [ -n "$kernel_module_rules" ]; then
        echo -e "\n4.1.3.19 Ensure kernel module loading, unloading, and modification is collected --> \e[32mpassed\e[0m\n"
        echo -e "On-disk configuration:\n$kernel_module_rules\n"
    else
        echo -e "\n4.1.3.19 Ensure kernel module loading, unloading, and modification is collected --> \e[31mfailed\e[0m\n"
        echo -e "Reason: The audit rule for kernel module events is not found or is incorrect.\n"
    fi
}

# Check on-disk configuration rules for kernel module events
check_on_disk_kernel_module_rules

# Check loaded rules for kernel module events
echo "Running configuration:"
loaded_kernel_module_rules=$(auditctl -l | awk '/^ *-a *always,exit/ \
&&/ -F *arch=b[2346]{2}/ \
&&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
&&/ -S/ \
&&(/init_module/ \
||/finit_module/ \
||/delete_module/ \
||/create_module/ \
||/query_module/) \
&&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')
if [ -n "$loaded_kernel_module_rules" ]; then
    echo "$loaded_kernel_module_rules"
fi

# Check symlinks for kmod
echo "Symlink audit:"
S_LINKS=$(ls -l /usr/sbin/lsmod /usr/sbin/rmmod /usr/sbin/insmod /usr/sbin/modinfo /usr/sbin/modprobe /usr/sbin/depmod | grep -v " -> /usr/bin/kmod" || true)
if [[ "${S_LINKS}" != "" ]]; then
    echo -e "Issue with symlinks:\n${S_LINKS}\n"
else
    echo "OK"
fi
