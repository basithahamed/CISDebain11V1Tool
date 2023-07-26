
#!/usr/bin/env bash

# Function to check if NIS client is not installed
check_nis_client_not_installed() {
  dpkg-query -W nis > /dev/null 2>&1
}

# Main script execution
{
  if check_nis_client_not_installed; then
    echo -e "\n2.3.1 Ensure NIS Client is not installed --> \e[32mPASS\e[0m"
    echo -e "NIS client is not installed.\n"
  else
    echo -e "\n2.3.1 Ensure NIS Client is not installed --> \e[31mFAIL\e[0m"
    echo -e "NIS client is installed.\n"
  fi
}
