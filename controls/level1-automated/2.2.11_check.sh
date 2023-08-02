#!/usr/bin/env bash

# Function to check if Samba is installed
check_samba_installed() {
  dpkg-query -W -f='${db:Status-Status}' samba 2>/dev/null | grep -q "installed"
}

# Main script execution
{
  if check_samba_installed; then
    echo -e "\n2.2.11 Ensure Samba is not installed --> \e[31mfailed\e[0m"
    echo -e "The Samba package is installed.\n"
  else
    echo -e "\n2.2.11 Ensure Samba is not installed --> \033[0;32mpassed\033[0m"
    echo -e "Samba is not installed.\n"
  fi
}
