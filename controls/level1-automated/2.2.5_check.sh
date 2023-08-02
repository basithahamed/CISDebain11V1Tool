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
    echo -e "\n2.2.5 Ensure LDAP Server is not installed --> \e[31mfailed\e[0m"
    echo -e "An LDAP server is installed:\n"
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' slapd 389-ds-base 2>/dev/null
  else
    echo -e "\n2.2.5 Ensure LDAP Server is not installed --> \033[0;32mpassed\033[0m"
    echo -e "No LDAP server is installed.\n"
  fi
}
