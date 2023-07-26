#!/usr/bin/env bash

# Function to check if X Window System is installed
check_x_installed() {
  dpkg-query -W xserver-xorg-core xserver-xorg > /dev/null 2>&1
}

# Main script execution
{
  if check_x_installed; then
    echo -e "\n2.2.1 Ensure X Window System is not installed --> \e[31mFAIL\e[0m"
    echo -e "X Window System is installed.\n"
  else
    echo -e "\n2.2.1 Ensure X Window System is not installed --> \e[32mPASS\e[0m"
    echo -e "X Window System is not installed.\n"
  fi
}
