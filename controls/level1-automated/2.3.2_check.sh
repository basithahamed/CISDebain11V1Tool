#!/usr/bin/env bash

# Function to check if rsh client is not installed
check_rsh_client_not_installed() {
  dpkg-query -W rsh-client > /dev/null 2>&1
}

# Main script execution
{
  if check_rsh_client_not_installed; then
    echo -e "\n2.3.2 Ensure rsh client is not installed --> \e[32mPASS\e[0m"
    echo -e "rsh client is not installed.\n"
  else
    echo -e "\n2.3.2 Ensure rsh client is not installed --> \e[31mFAIL\e[0m"
    echo -e "rsh client is installed.\n"
  fi
}
