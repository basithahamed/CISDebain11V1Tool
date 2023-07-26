#!/bin/bash

# Function to check if wireless interfaces are disabled
check_wireless_disabled() {
  if command -v nmcli >/dev/null 2>&1; then
    if nmcli radio all | grep -Eq '\s*\S+\s+disabled\s+\S+\s+disabled\b'; then
      echo "Wireless is not enabled"
      return 0
    else
      nmcli radio all
      return 1
    fi
  elif [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
    t=0
    mname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do basename "$(readlink -f "$driverdir"/device/driver/module)"; done | sort -u)
    for dm in $mname; do
      if grep -Eq "^\s*install\s+$dm\s+/bin/(true|false)" /etc/modprobe.d/*.conf; then
        /bin/true
      else
        echo "$dm is not disabled"
        t=1
      fi
    done
    if [ "$t" -eq 0 ]; then
      echo "Wireless is not enabled"
      return 0
    else
      return 1
    fi
  else
    echo "Wireless is not enabled"
    return 0
  fi
}

# Main script execution
if check_wireless_disabled; then
  echo -e "\n3.1.2 Ensure wireless interfaces are disabled --> \e[32mPASS\e[0m"
  echo "No wireless interfaces are active on the system."
  exit 0
else
  echo -e "\n3.1.2 Ensure wireless interfaces are disabled --> \e[31mFAIL\e[0m"
  echo "At least one wireless interface is enabled or not disabled."
  exit 1
fi
