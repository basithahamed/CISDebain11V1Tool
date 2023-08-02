#!/usr/bin/env bash

# Function to check if a service is essential or nonessential
check_nonessential_services() {
  local nonessential_services=("ftp" "telnet" "ldap" "rpcbind")
  local ss_output=$(ss -plntu 2>/dev/null)

  for service in "${nonessential_services[@]}"; do
    if echo "$ss_output" | grep -Eq "\s$service\s"; then
      echo -e "\n2.4 Ensure $service service is removed or masked --> \033[0;31mfailed\033[0m"
      echo "$service service is running."
      return 1
    fi
  done

  echo -e "\n2.4 Ensure nonessential services are removed or masked --> \033[0;32mpassed\033[0m"
  echo "All nonessential services are removed or masked."
  return 0
}

# Main script execution
check_nonessential_services
