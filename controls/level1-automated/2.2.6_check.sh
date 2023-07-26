#!/usr/bin/env bash

# Function to check if nfs-kernel-server is installed
check_nfs_installed() {
  nfs_status=$(dpkg-query -W -f='${db:Status-Status}' nfs-kernel-server 2>/dev/null)
  if [ "$nfs_status" = "installed" ]; then
    return 0
  fi

  return 1
}

# Main script execution
{
  if check_nfs_installed; then
    echo -e "\n2.2.6 Ensure NFS is not installed --> \e[31mFAIL\e[0m"
    echo -e "The NFS server package (nfs-kernel-server) is installed:\n"
    dpkg-query -W -f='${binary:Package}\t${Status}\t${db:Status-Status}\n' nfs-kernel-server 2>/dev/null
  else
    echo -e "\n2.2.6 Ensure NFS is not installed --> \e[32mPASS\e[0m"
    echo -e "The NFS server package (nfs-kernel-server) is not installed.\n"
  fi
}
