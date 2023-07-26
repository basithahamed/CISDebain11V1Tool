#!/usr/bin/env bash

# Function to check if CUPS is installed
check_cups_installed() {
  dpkg-query -W cups > /dev/null 2>&1
}

# Main script execution
{
  if check_cups_installed; then
    echo -e "\n2.2.3 Ensure CUPS is not installed --> \e[31mFAIL\e[0m"
    echo -e "CUPS is installed.\n"
  else
    echo -e "\n2.2.3 Ensure CUPS is not installed --> \e[32mPASS\e[0m"
    echo -e "CUPS is not installed.\n"
  fi
}
