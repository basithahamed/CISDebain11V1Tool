#!/usr/bin/env bash

# Function to check if GNOME Desktop Manager is installed
check_gdm_installed() {
  if command -v dpkg-query > /dev/null 2>&1; then
    dpkg-query -W gdm gdm3 > /dev/null 2>&1
  elif command -v rpm > /dev/null 2>&1; then
    rpm -q gdm gdm3 > /dev/null 2>&1
  fi
}

# Function to check if GDM disabling automatic mounting of removable media is not overridden
check_gdm_automatic_mounting_override() {
  l_pkgoutput=""
  l_output=""
  l_output2=""

  # Look for existing settings and set variables if they exist
  l_kfd="/etc/dconf/db/$(grep -Psril '^\h*automount\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d" # set directory of key file to be locked
  l_kfd2="/etc/dconf/db/$(grep -Psril '^\h*automount-open\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}').d" # set directory of key file to be locked

  # If key file directory doesn't exist, options can't be locked
  if [ -d "$l_kfd" ]; then
    if grep -Piq '^\h*\/org/gnome\/desktop\/media-handling\/automount\b' "$l_kfd"; then
      l_output="$l_output\n - \"automount\" is locked in: \"$l_kfd\""
    else
      l_output2="$l_output2\n - \"automount\" is not locked"
    fi
  else
    l_output2="$l_output2\n - \"automount\" is not set so it cannot be locked"
  fi

  # If key file directory doesn't exist, options can't be locked
  if [ -d "$l_kfd2" ]; then
    if grep -Piq '^\h*\/org/gnome\/desktop\/media-handling\/automount-open\b' "$l_kfd2"; then
      l_output="$l_output\n - \"automount-open\" is locked in: \"$l_kfd2\""
    else
      l_output2="$l_output2\n - \"automount-open\" is not locked"
    fi
  else
    l_output2="$l_output2\n - \"automount-open\" is not set so it cannot be locked"
  fi

  # Check if GNOME Desktop Manager is installed
  if check_gdm_installed; then
    [ -n "$l_output2" ] && echo -e "1.8.7 Ensure GDM disabling automatic mounting of removable media is not overridden --> \e[31mFAIL\e[0m$l_output2" || echo -e "1.8.7 Ensure GDM disabling automatic mounting of removable media is not overridden --> \e[32mPASS\e[0m$l_output"
  else
    echo -e "1.8.7 Ensure GDM disabling automatic mounting of removable media is not overridden --> \e[32mPASS\e[0m\n- GNOME Desktop Manager isn't installed\n- Recommendation is Not Applicable"
  fi
}

# Main script execution
check_gdm_automatic_mounting_override
