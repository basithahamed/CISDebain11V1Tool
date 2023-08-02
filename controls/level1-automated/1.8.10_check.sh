#!/usr/bin/env bash

# Function to check if the specified configuration line exists in /etc/gdm3/custom.conf
check_custom_gdm_configuration() {
  if grep -Eis '^\s*Enable\s*=\s*true' /etc/gdm3/custom.conf > /dev/null 2>&1; then
    echo -e "1.8.10 Ensure GDM custom.conf configuration 'Enable' is not set to true --> \e[31mfailed\e[0m\n - The 'Enable' configuration is set to true in /etc/gdm3/custom.conf"
  else
    echo -e "1.8.10 Ensure GDM custom.conf configuration 'Enable' is not set to true --> \033[0;32mpassed\033[0m - The 'Enable' configuration is not set to true in /etc/gdm3/custom.conf"
  fi
}

# Main script execution
check_custom_gdm_configuration
