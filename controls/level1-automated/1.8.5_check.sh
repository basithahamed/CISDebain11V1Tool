#!/usr/bin/env bash

# Function to check if GNOME Desktop Manager is installed
check_gdm_installed() {
  if command -v dpkg-query > /dev/null 2>&1; then
    dpkg-query -W gdm gdm3 > /dev/null 2>&1
  elif command -v rpm > /dev/null 2>&1; then
    rpm -q gdm gdm3 > /dev/null 2>&1
  fi
}

# Function to check if GDM screen locks can be overridden
check_gdm_screen_lock_override() {
  local l_output=""
  local l_output2=""

  local l_kfd="/etc/dconf/db/$(grep -Psril '^\h*idle-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"
  local l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*lock-delay\h*=\h*uint32\h+\d+\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d"

  if [ -d "$l_kfd" ]; then
    if grep -Prilq '\/org\/gnome\/desktop\/session\/idle-delay\b' "$l_kfd"; then
      l_output="$l_output\n - \"idle-delay\" is locked in \"$(grep -Pril '\/org\/gnome\/desktop\/session\/idle-delay\b' "$l_kfd")\""
    else
      l_output2="$l_output2\n - \"idle-delay\" is not locked"
    fi
  else
    l_output2="$l_output2\n - \"idle-delay\" is not set so it cannot be locked"
  fi

  if [ -d "$l_kfd2" ]; then
    if grep -Prilq '\/org\/gnome\/desktop\/screensaver\/lock-delay\b' "$l_kfd2"; then
      l_output="$l_output\n - \"lock-delay\" is locked in \"$(grep -Pril '\/org\/gnome\/desktop\/screensaver\/lock-delay\b' "$l_kfd2")\""
    else
      l_output2="$l_output2\n - \"lock-delay\" is not locked"
    fi
  else
    l_output2="$l_output2\n - \"lock-delay\" is not set so it cannot be locked"
  fi

  if [ -z "$l_output2" ]; then
    echo -e "1.8.5 Ensure GDM screen locks cannot be overridden --> \033[0;32mpassed\033[0m$l_output"
  else
    echo -e "1.8.5 Ensure GDM screen locks cannot be overridden --> \e[31mfailed\e[0m$l_output2"
    [ -n "$l_output" ] && echo -e "- Correctly set:$l_output"
  fi
}

# Main script execution
if check_gdm_installed; then
  check_gdm_screen_lock_override
else
  echo -e "1.8.5 Ensure GDM screen locks cannot be overridden --> \033[0;32mpassed\033[0m- GNOME Desktop Manager isn't installed\n- Recommendation is Not Applicable"
fi
