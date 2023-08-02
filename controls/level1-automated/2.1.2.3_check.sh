#!/usr/bin/env bash

# Function to check if chrony is installed
check_chrony_installed() {
  dpkg-query -W chrony > /dev/null 2>&1
}

# Function to check if chrony service is enabled
check_chrony_enabled() {
  local is_enabled=$(systemctl is-enabled chrony 2>&1)

  if [ "$is_enabled" == "enabled" ]; then
    echo -e "\n2.1.2.3 Ensure chrony is enabled and running --> \033[0;32mpassed\033[0m"
    echo -e "Chrony service is enabled.\n"
  else
    echo -e "\n2.1.2.3 Ensure chrony is enabled and running --> \e[31mfailed\e[0m"
    echo -e "Chrony service is not enabled.\n"
  fi
}

# Function to check if chrony service is running
check_chrony_running() {
  local is_running=$(systemctl is-active chrony 2>&1)

  if [ "$is_running" == "active" ]; then
    echo -e "\n2.1.2.3 Ensure chrony is enabled and running --> \033[0;32mpassed\033[0m"
    echo -e "Chrony service is running.\n"
  else
    echo -e "\n2.1.2.3 Ensure chrony is enabled and running --> \e[31mfailed\e[0m"
    echo -e "Chrony service is not running.\n"
  fi
}

# Main script execution
{
  check_chrony_installed
  check_chrony_enabled
  check_chrony_running
}
