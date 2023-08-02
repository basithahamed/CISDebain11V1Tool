#!/usr/bin/env bash

# Function to check if Mail Transfer Agent is configured for local-only mode
check_mta_local_only() {
  local_only=$(ss -lntu | grep -E ':25\s' | grep -E -v '\s(127.0.0.1|::1):25\s')
  if [ -z "$local_only" ]; then
    return 0  # Local-only mode is configured
  else
    return 1  # Local-only mode is not configured
  fi
}

# Main script execution
{
  if check_mta_local_only; then
    echo -e "\n2.2.15 Ensure mail transfer agent is configured for local-only mode --> \033[0;32mpassed\033[0m"
    echo -e "Mail Transfer Agent is configured for local-only mode.\n"
  else
    echo -e "\n2.2.15 Ensure mail transfer agent is configured for local-only mode --> \e[31mfailed\e[0m"
    echo -e "Mail Transfer Agent is not configured for local-only mode.\n"
  fi
}
