#!/usr/bin/env bash

# Function to check if chrony is installed
check_chrony_installed() {
  dpkg-query -W chrony > /dev/null 2>&1
}

# Function to check if the chrony configuration contains authorized timeservers
check_chrony_config() {
  local pool_lines=0
  local server_lines=0
  local output=""

  while IFS= read -r line; do
    if [[ "$line" =~ ^\h*(pool|server)\h+ ]]; then
      if [[ "$line" =~ ^\h*pool\h+ ]]; then
        ((pool_lines++))
      elif [[ "$line" =~ ^\h*server\h+ ]]; then
        ((server_lines++))
      fi
      output="$output\n$line"
    fi
  done < <(grep -Pr --include=*.{sources,conf} '^\h*(pool|server)\h+\H+' /etc/chrony/)

  if [ "$pool_lines" -ge 1 ] && [ "$server_lines" -ge 3 ]; then
    echo -e "\n2.1.2 Ensure chrony is configured with authorized timeserver --> \e[32mpassed\e[0m"
    echo -e "Authorized timeservers are configured in the chrony configuration:"
    echo -e "$output\n"
  else
    echo -e "\n2.1.2 Ensure chrony is configured with authorized timeserver --> \e[31mfailed\e[0m"
    echo -e "Authorized timeservers are not configured in the chrony configuration.\n"
  fi
}

# Main script execution
{
  check_chrony_installed && check_chrony_config
}
