#!/usr/bin/env bash

# Function to check if Apache HTTP server is installed
check_apache_installed() {
  apache_status=$(dpkg-query -W -f='${db:Status-Status}' apache2 2>/dev/null)
  if [ "$apache_status" = "installed" ]; then
    return 0
  fi

  return 1
}

# Main script execution
{
  if check_apache_installed; then
    echo -e "\n2.2.9 Ensure HTTP Server is not installed --> \e[31mFAIL\e[0m"
    echo -e "The Apache HTTP server package (apache2) is installed:\n"
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' apache2 2>/dev/null
  else
    echo -e "\n2.2.9 Ensure HTTP Server is not installed --> \e[32mPASS\e[0m"
    echo -e "The Apache HTTP server package (apache2) is not installed.\n"
  fi
}
