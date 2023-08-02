#!/usr/bin/env bash

# Function to check if chrony is installed
check_chrony_installed() {
  dpkg-query -W chrony > /dev/null 2>&1
}

# Function to check if ntp is installed
check_ntp_installed() {
  dpkg-query -W ntp > /dev/null 2>&1
}

# Function to check if systemd-timesyncd is enabled
check_systemd_timesyncd_enabled() {
  systemctl is-enabled systemd-timesyncd.service 2>&1 | grep -q 'enabled'
}

# Main script execution
{
  output=""
  check_chrony_installed && l_chrony="y" || l_chrony=""
  check_ntp_installed && l_ntp="y" || l_ntp=""
  check_systemd_timesyncd_enabled && l_sdtd="y" || l_sdtd=""

  if [[ "$l_chrony" = "y" && -z "$l_ntp" && -z "$l_sdtd" ]]; then
    l_tsd="chrony"
    output="$output\n- chrony is in use on the system"
  elif [[ -z "$l_chrony" && "$l_ntp" = "y" && -z "$l_sdtd" ]]; then
    l_tsd="ntp"
    output="$output\n- ntp is in use on the system"
  elif [[ -z "$l_chrony" && -z "$l_ntp" && "$l_sdtd" = "y" ]]; then
    l_tsd="sdtd"
    output="$output\n- systemd-timesyncd is in use on the system"
  elif [[ -z "$l_chrony" && -z "$l_ntp" && -z "$l_sdtd" ]]; then
    l_tsd="none"
    output="$output\n- No time synchronization daemon is in use on the system"
  else
    output="$output\n- Multiple time synchronization daemons are in use on the system"
  fi

  if [ "$l_tsd" = "none" ] || [ "$l_tsd" = "chrony" ] || [ "$l_tsd" = "ntp" ] || [ "$l_tsd" = "sdtd" ]; then
    echo -e "\n2.1.1.1 Ensure a single time synchronization daemon is in use --> \033[0;32mpassed\033[0m$output\n"
  else
    echo -e "\n2.1.1.1 Ensure a single time synchronization daemon is in use --> \e[31mfailed\e[0m$output\n"
  fi
}
