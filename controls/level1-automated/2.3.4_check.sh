#!/usr/bin/env bash

# Function to check if the telnet client is installed
check_telnet_client_installed() {
  dpkg-query -W telnet > /dev/null 2>&1
}

# Define ANSI color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Main script execution
if check_telnet_client_installed; then
  echo -e "\n2.3.4 Ensure telnet client is not installed --> ${RED}FAIL${NC}"
  echo "Telnet client is installed."
  exit 1
else
  echo -e "\n2.3.4 Ensure telnet client is not installed --> ${GREEN}passed${NC}"
  echo "Telnet client is not installed."
  exit 0
fi
