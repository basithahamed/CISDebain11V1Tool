#!/usr/bin/env bash

# Function to check if RPC is installed
check_rpc_installed() {
  dpkg-query -W rpcbind > /dev/null 2>&1
}

# Define ANSI color escape codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Main script execution
if check_rpc_installed; then
  echo -e "\n2.3.6 Ensure RPC is not installed --> ${RED}FAIL${NC}"
  echo "RPC is installed."
else
  echo -e "\n2.3.6 Ensure RPC is not installed --> ${GREEN}PASS${NC}"
  echo "RPC is not installed."
fi
