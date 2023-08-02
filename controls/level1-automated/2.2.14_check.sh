#!/usr/bin/env bash

# Function to check if NIS Server is installed
check_nis_installed() {
  dpkg-query -W -f='${Status}' nis 2>/dev/null | grep -q "install ok installed"
}

# Main script execution
{
  if check_nis_installed; then
    echo -e "\n2.2.14 Ensure NIS Server is not installed --> \e[31mfailed\e[0m"
    echo -e "The NIS package is installed.\n"
  else
    echo -e "\n2.2.14 Ensure NIS Server is not installed --> \033[0;32mpassed\033[0m"
    echo -e "NIS Server is not installed.\n"
  fi
}
