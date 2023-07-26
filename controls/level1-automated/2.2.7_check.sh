#!/usr/bin/env bash

# Function to check if DNS packages are installed
check_dns_installed() {
  dpkg-query -W bind9 > /dev/null 2>&1 || dpkg-query -W bind > /dev/null 2>&1
}

# Main script execution
{
  if check_dns_installed; then
    echo -e "\n2.2.7 Ensure DNS Server is not installed --> \e[31mFAIL\e[0m"
    echo -e "DNS packages are installed.\n"
  else
    echo -e "\n2.2.7 Ensure DNS Server is not installed --> \e[32mPASS\e[0m"
    echo -e "DNS server is not installed.\n"
  fi
}
