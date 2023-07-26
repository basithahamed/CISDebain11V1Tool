#!/usr/bin/env bash

# Function to check if Avahi Server is installed
check_avahi_installed() {
  dpkg-query -W avahi-daemon > /dev/null 2>&1
}

# Main script execution
{
  if check_avahi_installed; then
    echo -e "\n2.2.2 Ensure Avahi Server is not installed --> \e[31mFAIL\e[0m"
    echo -e "Avahi Server is installed.\n"
  else
    echo -e "\n2.2.2 Ensure Avahi Server is not installed --> \e[32mPASS\e[0m"
    echo -e "Avahi Server is not installed.\n"
  fi
}
