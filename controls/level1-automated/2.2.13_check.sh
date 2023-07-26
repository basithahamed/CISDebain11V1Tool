#!/usr/bin/env bash

# Function to check if SNMP Server is installed
check_snmp_installed() {
  dpkg-query -W -f='${Status}' snmp 2>/dev/null | grep -q "install ok installed"
}

# Main script execution
{
  if check_snmp_installed; then
    echo -e "\n2.2.13 Ensure SNMP Server is not installed --> \e[31mFAIL\e[0m"
    echo -e "The SNMP package is installed.\n"
  else
    echo -e "\n2.2.13 Ensure SNMP Server is not installed --> \e[32mPASS\e[0m"
    echo -e "SNMP Server is not installed.\n"
  fi
}
