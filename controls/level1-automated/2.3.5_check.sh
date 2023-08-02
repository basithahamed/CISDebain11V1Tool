#!/usr/bin/env bash

# Function to check if the LDAP client is installed
check_ldap_client_installed() {
  dpkg-query -W ldap-utils | grep -qi "installed"
}

# Define ANSI color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Main script execution
if check_ldap_client_installed; then
  echo -e "\n2.3.5 Ensure LDAP client is not installed --> ${RED}FAIL${NC}"
  echo "LDAP client is installed."
else
  echo -e "\n2.3.5 Ensure LDAP client is not installed --> ${GREEN}passed${NC}"
  echo "LDAP client is not installed."
fi
