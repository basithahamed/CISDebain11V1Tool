#!/usr/bin/env bash

# Function to check if chrony is installed
check_chrony_installed() {
  dpkg-query -W chrony > /dev/null 2>&1
}

# Function to check if chrony is running as user _chrony
check_chrony_user() {
  local chrony_user=$(ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print $1 }')

  if [ -z "$chrony_user" ]; then
    echo -e "\n2.1.2.2 Ensure chrony is running as user _chrony --> \033[0;32mpassed\033[0m"
    echo -e "Chronyd service is running as the _chrony user.\n"
  else
    echo -e "\n2.1.2.2 Ensure chrony is running as user _chrony --> \e[31mfailed\e[0m"
    echo -e "Chronyd service is not running as the _chrony user.\n"
  fi
}

# Main script execution
{
  check_chrony_installed && check_chrony_user
}
