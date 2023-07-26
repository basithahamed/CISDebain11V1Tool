#!/usr/bin/env bash

# Function to check if rsync service is either not installed or masked
check_rsync_installed_or_masked() {
  dpkg-query -W rsync > /dev/null 2>&1
  rsync_status=$?
  masked_status=$(systemctl is-enabled rsync 2>/dev/null | grep -i 'masked' | wc -l)
  
  if [ $rsync_status -eq 0 ] || [ $masked_status -gt 0 ]; then
    return 1  # rsync service is installed or masked
  else
    return 0  # rsync service is not installed or masked
  fi
}

# Main script execution
{
  if check_rsync_installed_or_masked; then
    echo -e "\n2.2.16 Ensure rsync service is either not installed or masked --> \e[32mPASS\e[0m"
    echo -e "rsync service is either not installed or masked.\n"
  else
    echo -e "\n2.2.16 Ensure rsync service is either not installed or masked --> \e[31mFAIL\e[0m"
    echo -e "rsync service is installed and not masked.\n"
  fi
}
