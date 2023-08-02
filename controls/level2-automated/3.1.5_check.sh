#!/usr/bin/env bash

# Function to check if RDS is installed
check_rds_installed() {
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' rds-tools | grep -q 'install'
}

# Function to check if RDS is disabled
check_rds_disabled() {
    l_output=""
    l_output2=""
    l_mname="rds" # set module name

    # Check if the module exists on the system
    if ! check_rds_installed; then
        echo -e "\n3.1.5 Ensure RDS is disabled --> \e[32mpassed\e[0m"
        echo -e "RDS is not installed.\n"
        return 0
    fi

    # Check how the module will be loaded
    l_loadable="$(modprobe -n -v "$l_mname")"
    [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
    if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
        l_output="$l_output\n - module: \"$l_mname\" is not loadable: \"$l_loadable\""
    else
        l_output2="$l_output2\n - module: \"$l_mname\" is loadable: \"$l_loadable\""
    fi

    # Check if the module is currently loaded
    if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
        l_output="$l_output\n - module: \"$l_mname\" is not loaded"
    else
        l_output2="$l_output2\n - module: \"$l_mname\" is loaded"
    fi

    # Check if the module is deny-listed
    if modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$l_mname\b"; then
        l_output="$l_output\n - module: \"$l_mname\" is deny-listed in: \"$(grep -Pl -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*)\""
    else
        l_output2="$l_output2\n - module: \"$l_mname\" is not deny-listed"
    fi

    # Report results. If no failures output in l_output2, we pass
    if [ -z "$l_output2" ]; then
        echo -e "\n3.1.5 Ensure RDS is disabled --> \e[32mpassed\e[0m"
        echo -e "RDS is disabled.\n"
        return 0
    else
        echo -e "\n3.1.5 Ensure RDS is disabled --> \e[31mfailed\e[0m"
        echo -e "RDS is enabled or not disabled.\n"
        [ -n "$l_output" ] && echo -e "\n$l_output\n"
        return 1
    fi
}

# Main script execution
check_rds_disabled
