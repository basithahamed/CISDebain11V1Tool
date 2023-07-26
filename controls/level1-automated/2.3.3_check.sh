#!/usr/bin/env bash

# Function to check if talk client is installed
check_talk_client_installed() {
  dpkg-query -W talk > /dev/null 2>&1
}

# Define ANSI color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Main script execution
if check_talk_client_installed; then
  echo -e "\n2.3.3 Ensure talk client is not installed --> ${RED}FAIL${NC}"
  echo "Talk client is installed."
  exit 1
else
  echo -e "\n2.3.3 Ensure talk client is not installed --> ${GREEN}PASS${NC}"
  echo "Talk client is not installed."
  exit 0
fi
