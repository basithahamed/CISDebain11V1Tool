#!/bin/bash

# Function to check the time synchronization daemon in use
check_time_sync_daemon() {
    output=""
    l_tsd=""
    l_sdtd=""
    l_ntp=""

    dpkg-query -W chrony > /dev/null 2>&1 && l_chrony="y"
    dpkg-query -W ntp > /dev/null 2>&1 && l_ntp="y" || l_ntp=""
    systemctl list-units --all --type=service | grep -q 'systemd-timesyncd.service' && systemctl is-enabled systemd-timesyncd.service | grep -q 'enabled' && l_sdtd="y"

    if [[ "$l_chrony" = "y" && "$l_ntp" != "y" && "$l_sdtd" != "y" ]]; then
        l_tsd="chrony"
        output="$output\n- chrony is in use on the system"
    elif [[ "$l_chrony" != "y" && "$l_ntp" = "y" && "$l_sdtd" != "y" ]]; then
        l_tsd="ntp"
        output="$output\n- ntp is in use on the system"
    elif [[ "$l_chrony" != "y" && "$l_ntp" != "y" ]]; then
        if systemctl list-units --all --type=service | grep -q 'systemd-timesyncd.service' && systemctl is-enabled systemd-timesyncd.service | grep -Eq '(enabled|disabled|masked)'; then
            l_tsd="sdtd"
            output="$output\n- systemd-timesyncd is in use on the system"
        fi
    else
        [[ "$l_chrony" = "y" && "$l_ntp" = "y" ]] && output="$output\n- both chrony and ntp are in use on the system"
        [[ "$l_chrony" = "y" && "$l_sdtd" = "y" ]] && output="$output\n- both chrony and systemd-timesyncd are in use on the system"
        [[ "$l_ntp" = "y" && "$l_sdtd" = "y" ]] && output="$output\n- both ntp and systemd-timesyncd are in use on the system"
    fi

    if [ -n "$l_tsd" ]; then
        echo -e "\n2.1.1.1 Ensure a single time synchronization daemon is in use --> \e[32mpassed\e[0m:\n$output\n"
    else
        echo -e "\n2.1.1.1 Ensure a single time synchronization daemon is in use --> \e[31mfailed\e[0m:\n$output\n"
    fi
}

# Call the function to check the time synchronization daemon in use
check_time_sync_daemon
