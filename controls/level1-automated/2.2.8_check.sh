#!/usr/bin/env bash

# Function to check if vsftpd is installed
check_vsftpd_installed() {
  vsftpd_status=$(dpkg-query -W -f='${db:Status-Status}' vsftpd 2>/dev/null)
  if [ "$vsftpd_status" = "installed" ]; then
    return 0
  fi

  return 1
}

# Main script execution
{
  if check_vsftpd_installed; then
    echo -e "\n2.2.8 Ensure FTP Server is not installed --> \e[31mFAIL\e[0m"
    echo -e "The FTP server package (vsftpd) is installed:\n"
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' vsftpd 2>/dev/null
  else
    echo -e "\n2.2.8 Ensure FTP Server is not installed --> \e[32mPASS\e[0m"
    echo -e "The FTP server package (vsftpd) is not installed.\n"
  fi
}
