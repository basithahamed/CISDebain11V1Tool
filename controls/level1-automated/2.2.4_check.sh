#!/usr/bin/env bash

# Function to check if DHCP server is installed
check_dhcp_server_installed() {
  dpkg-query -W isc-dhcp-server > /dev/null 2>&1 || dpkg-query -W dhcpd > /dev/null 2>&1
}

# Main script execution
{
  if check_dhcp_server_installed; then
    echo -e "\n2.2.4 Ensure DHCP Server is not installed --> \e[31mfailed\e[0m"
    echo -e "A DHCP server is installed.\n"
  else
    echo -e "\n2.2.4 Ensure DHCP Server is not installed --> \033[0;32mpassed\033[0m"
    echo -e "No DHCP server is installed.\n"
  fi
}
