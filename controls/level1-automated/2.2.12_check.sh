#!/usr/bin/env bash

# Function to check if Squid HTTP Proxy Server is installed
check_squid_installed() {
  dpkg-query -W -f='${db:Status-Status}' squid 2>/dev/null | grep -q "installed"
}

# Main script execution
{
  if check_squid_installed; then
    echo -e "\n2.2.12 Ensure HTTP Proxy Server is not installed --> \e[31mfailed\e[0m"
    echo -e "The Squid package is installed.\n"
  else
    echo -e "\n2.2.12 Ensure HTTP Proxy Server is not installed --> \033[0;32mpassed\033[0m"
    echo -e "Squid HTTP Proxy Server is not installed.\n"
  fi
}
