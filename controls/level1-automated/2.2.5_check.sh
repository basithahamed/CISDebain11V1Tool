#!/usr/bin/env bash

# Function to check if LDAP server is installed
check_ldap_server_installed() {
  ldap_status=$(dpkg-query -W -f='${db:Status-Status}' slapd 2>/dev/null)
  if [ "$ldap_status" = "installed" ]; then
    return 0
  fi

  ds_status=$(dpkg-query -W -f='${db:Status-Status}' 389-ds-base 2>/dev/null)
  if [ "$ds_status" = "installed" ]; then
    return 0
  fi

  return 1
}

# Main script execution
{
  if check_ldap_server_installed; then
    echo -e "\n2.2.5 Ensure LDAP Server is not installed --> \e[31mFAIL\e[0m"
    echo -e "An LDAP server is installed:\n"
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' slapd 389-ds-base 2>/dev/null
  else
    echo -e "\n2.2.5 Ensure LDAP Server is not installed --> \e[32mPASS\e[0m"
    echo -e "No LDAP server is installed.\n"
  fi
}
